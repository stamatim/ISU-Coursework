#define RETSIGTYPE void
#include <sys/types.h>
#include <sys/time.h>
#include <netinet/in.h>
#include <pcap.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#ifndef setsignal_h
#define setsignal_h

RETSIGTYPE (*setsignal(int, RETSIGTYPE (*)(int)))(int);
#endif

char cpre580f98[] = "netdump";

void raw_print(u_char *user, const struct pcap_pkthdr *h, const u_char *p);

int packettype;

char *program_name;

/* Externs */
extern void bpf_dump(const struct bpf_program *, int);

extern char *copy_argv(char **);

/* Forwards */
void program_ending(int);

/* Length of saved portion of packet. */
int snaplen = 1500;;

static pcap_t *pd;

extern int optind;
extern int opterr;
extern char *optarg;
int pflag = 0, aflag = 0;

int numIP = 0; // counter for number of seen IP addresses
int numARP = 0; // counter for number of seen ARP addresses
int numICMP = 0; // counter for number of seen ICMP packets
int numTCP = 0; // counter for number of seen TCP packets

int
main(int argc, char **argv)
{
	int cnt, op, i, done = 0;
	bpf_u_int32 localnet, netmask;
	char *cp, *cmdbuf, *device;
	struct bpf_program fcode;
	 void (*oldhandler)(int);
	u_char *pcap_userdata;
	char ebuf[PCAP_ERRBUF_SIZE];

	cnt = -1;
	device = NULL;
	
	if ((cp = strrchr(argv[0], '/')) != NULL)
		program_name = cp + 1;
	else
		program_name = argv[0];

	opterr = 0;
	while ((i = getopt(argc, argv, "pa")) != -1)
	{
		switch (i)
		{
		case 'p':
			pflag = 1;
		break;
		case 'a':
			aflag = 1;
		break;
		case '?':
		default:
			done = 1;
		break;
		}
		if (done) break;
	}
	if (argc > (optind)) cmdbuf = copy_argv(&argv[optind]);
		else cmdbuf = "";

	if (device == NULL) {
		device = pcap_lookupdev(ebuf);
		if (device == NULL)
			error("%s", ebuf);
	}
	pd = pcap_open_live(device, snaplen,  1, 1000, ebuf);
	if (pd == NULL)
		error("%s", ebuf);
	i = pcap_snapshot(pd);
	if (snaplen < i) {
		warning("snaplen raised from %d to %d", snaplen, i);
		snaplen = i;
	}
	if (pcap_lookupnet(device, &localnet, &netmask, ebuf) < 0) {
		localnet = 0;
		netmask = 0;
		warning("%s", ebuf);
	}
	/*
	 * Let user own process after socket has been opened.
	 */
	setuid(getuid());

	if (pcap_compile(pd, &fcode, cmdbuf, 1, netmask) < 0)
		error("%s", pcap_geterr(pd));
	
	(void)setsignal(SIGTERM, program_ending);
	(void)setsignal(SIGINT, program_ending);
	/* Cooperate with nohup(1) */
	if ((oldhandler = setsignal(SIGHUP, program_ending)) != SIG_DFL)
		(void)setsignal(SIGHUP, oldhandler);

	if (pcap_setfilter(pd, &fcode) < 0)
		error("%s", pcap_geterr(pd));
	pcap_userdata = 0;
	(void)fprintf(stderr, "%s: listening on %s\n", program_name, device);
	if (pcap_loop(pd, cnt, raw_print, pcap_userdata) < 0) {
		(void)fprintf(stderr, "%s: pcap_loop: %s\n",
		    program_name, pcap_geterr(pd));
		exit(1);
	}
	pcap_close(pd);
	exit(0);
}

/* routine is executed on exit */
void program_ending(int signo)
{
	struct pcap_stat stat;

	if (pd != NULL && pcap_file(pd) == NULL) {
		(void)fflush(stdout);
		putc('\n', stderr);
		if (pcap_stats(pd, &stat) < 0)
			(void)fprintf(stderr, "pcap_stats: %s\n", pcap_geterr(pd));
		else {
			(void)fprintf(stderr, "%d packets received by filter\n",stat.ps_recv);
			(void)fprintf(stderr, "%d packets dropped by kernel\n",stat.ps_drop);
			(void)fprintf(stderr, "%d packets seen with IPv4 type\n",numIP);
			(void)fprintf(stderr, "%d packets seen with ARP type\n",numARP);
			(void)fprintf(stderr, "%d packets seen with ICMP type\n",numICMP);
			(void)fprintf(stderr, "%d packets seen with TCP type\n",numTCP);
		}
	}
	exit(0);
}

/* Like default_print() but data need not be aligned */
void
default_print_unaligned(register const u_char *cp, register u_int length)
{
	register u_int i, s;
	register int nshorts;

	nshorts = (u_int) length / sizeof(u_short);
	i = 0;
	while (--nshorts >= 0) {
		if ((i++ % 8) == 0)
			(void)printf("\n\t\t\t");
		s = *cp++;
		(void)printf(" %02x%02x", s, *cp++);
	}
	if (length & 1) {
		if ((i % 8) == 0)
			(void)printf("\n\t\t\t");
		(void)printf(" %02x", *cp);
	}
}

/*
 * By default, print the packet out in hex.
 */
void
default_print(register const u_char *bp, register u_int length)
{
	register const u_short *sp;
	register u_int i;
	register int nshorts;

	if ((long)bp & 1) {
		default_print_unaligned(bp, length);
		return;
	}
	sp = (u_short *)bp;
	nshorts = (u_int) length / sizeof(u_short);
	i = 0;
	while (--nshorts >= 0) {
		if ((i++ % 8) == 0)
			(void)printf("\n\t");
		(void)printf(" %04x", ntohs(*sp++));
	}
	if (length & 1) {
		if ((i % 8) == 0)
			(void)printf("\n\t");
		(void)printf(" %02x", *(u_char *)sp);
	}
}

/*
insert your code in this routine

*/

void raw_print(u_char *user, const struct pcap_pkthdr *h, const u_char *p)
{
        u_int length = h->len;
        u_int caplen = h->caplen;
	uint16_t e_type; 
	uint16_t checksum;

        default_print(p, caplen);
        putchar('\n');


	printf("========Decoding Ethernet Header=========\n");

	// print dest address (p[0-5])
	printf("Destination Address: %02X:%02X:%02X:%02X:%02X:%02X\n", p[0], p[1], p[2], p[3], p[4], p[5]);

	// print source address (p[6-11])
	printf("Source Address: %02X:%02X:%02X:%02X:%02X:%02X\n", p[6], p[7], p[8], p[9], p[10], p[11]);

	// print type/len
	e_type = p[12] * 256 + p[13];
	printf("Type: 0x%04X\n", e_type);

	// print ethernet protocol
	printf("Payload ");
	if (e_type == 0x0800) {
		numIP++; // seen IP address
		printf(" --> IPv4\n");
	}
	if (e_type == 0x0806) {
		numARP++; // seen ARP address
		printf(" --> ARP\n");
	}

	/* ARP Header */
	if (e_type == 0x0806) {
	
		printf("\n\t=========Decoding ARP Header=========\n");
		// print hardware type
		printf("\tHardware Type: %02X%02X\n", p[14], p[15]);

		// print protocol type
		printf("\tProtocol Type: %02X%02X\n", p[16], p[17]);

		// print hardware length
		printf("\tHardware Length: %02X\n", p[18]);

		// print protocol length
		printf("\tProtocol Length: %02X\n", p[19]);

		// print operation
		printf("\tOperation: %02X%02X\n", p[20], p[21]);

		// sender hardware address
		printf("\tSender Hardware Address: %02X:%02X:%02X:%02X:%02X:%02X\n", p[22], p[23], p[24], p[25], p[26], p[27]);

		// sender protocol address
		printf("\tSender Protocol Address: %d.%d.%d.%d\n", p[28], p[29], p[30], p[31]);

		// target hardware address
		printf("\tTarget Hardware Address: %02X:%02X:%02X:%02X:%02X:%02X\n", p[32], p[33], p[34], p[35], p[36], p[37]);

		// target protocol address
		printf("\tTarget Protocol Address: %d.%d.%d.%d\n", p[38], p[39], p[40], p[41]);

	}

	/* IP Header */
	if (e_type == 0x0800) {
		printf("\n\t=========Decoding IP Header=========\n");
		// print version number and header length
		int hlen = p[14] & 0x0F; // header length
		printf("\tVersion Number: %d\n", p[14] >> 4);
		printf("\tHeader Length: %d\n", hlen* 4);

		// print type of service
		printf("\tType of service: %02X\n", p[15]);

		// print length of payload
		printf("\tLength: %02X%02X\n", p[16], p[17]);

		// print identifier
		printf("\tID: %02X%02X\n", p[18], p[19]);

		// print flags
		printf("\tFlags: %02X\n", p[20]);

		// print offset
		printf("\tOffset: %02X\n", p[21] << 3);

		// print ttl
		printf("\tTTL: %02X\n", p[22]);

		// print protocol
		uint8_t protocol = p[23];
		if (protocol = 6) {
			printf("\tProtocol: %d -> TCP\n", protocol);
			numTCP++;
		}
		if (protocol = 1) {
			printf("\tProtocol: %d -> ICMP\n", protocol);
			numICMP++;
		}

		// print checksum
		checksum = p[24] * 256 + p[25];
		printf("\tChecksum: 0x%04X\n", checksum);
		
		// print source ip
		printf("\tSource IP Address: %d.%d.%d.%d\n", p[26], p[27], p[28], p[29]);

		// print dest ip
		printf("\tDestination IP Address: %d.%d.%d.%d\n\n", p[30], p[31], p[32], p[33]);


		/* ICMP Header */
		if (protocol == 1) {
			printf("\t\t=========Decoding ICMP Header=========\n");
			printf("\t\tType: %d\n", p[34]);
			printf("\t\tCode: %d\n", p[35]);
			printf("\t\tChecksum: 0x%04X\n", (p[36] * 256 + p[37]));
			printf("\t\tParameter: 0x%02X%02X%02X%02X\n", p[38], p[39], p[40], p[41]);


		}
		/* TCP Header */
		if (protocol == 6) {
			printf("\t\t=========Decoding TCP Header=========\n");
			uint16_t spn = p[34] * 256 + p[35];
			printf("\t\tSource Port Number: %d\n", spn);
			uint16_t dpn = p[36] * 256 + p[37];
			printf("\t\tDestination Port Number: %d\n", dpn);
			printf("\t\tSequence Number: 0x%02X%02X%02X%02X\n", p[38], p[39], p[40], p[41]);
			printf("\t\tAcknowledgement Number: 0x%02X%02X%02X%02X\n", p[42], p[43], p[44], p[45]);
			printf("\t\tHeader Length: %d bytes\n", p[46] >> 4);
			printf("\t\tReserved: 0\n");
			printf("\t\tFlags: %d\n", (p[47] & 0x3F));
			uint16_t ws = p[48] * 256 + p[49];
			printf("\t\tWindow Size: %d\n", ws);
			printf("\t\tChecksum: 0x%04X\n", (p[50] * 256 + p[51]));
			printf("\t\tUrgent Pointer: 0x%04X\n", (p[52] * 256 + p[53]));
		}



	}

}

