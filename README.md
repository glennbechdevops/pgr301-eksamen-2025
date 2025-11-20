# PGR301 EKSAMEN 2025 - AiAlpha: Sentimentanalyse for Big Tech

<img width="1181" alt="image" src="media/banner_wave.png">

Som nyansatt utvikler i **AiAlpha** – en hyperambisiøs startup grunnlagt av en selverklært AI-visionær fra Kristiania (klasse 2023, selvfølgelig) – har du fått plass på raketten som skal revolusjonere finansmarkedet … igjen.

Selskapet hevder å levere «sanntids sentimentanalyse av Big Tech-nyheter» – altså lese nettaviser og prøve å gjette om markedet er i FOMO- eller panic-sell-modus. Kundene er en fargerik blanding av daytradere og Discord-entusiaster med sterke meninger om markedet og svært begrenset tålmodighet.

Gründeren har til nå utviklet løsningen alene, hovedsakelig gjennom «vibe-coding» med AI-assistanse. Prototypen er bygget med AWS SAM og Python, inspirert av Øving 4 i PGR301, og fungerer på et grunnleggende nivå. Likevel baserer den seg på AWS Comprehend i en form som gir for grovkornede resultater – sentiment beregnes på dokumentnivå, noe som ikke gir den detaljerte innsikten løsningen trenger.

Han har også eksperimentert med en Java-basert modell som gir bedre faglige resultater, men kodebasen har nå nådd et modenhetspunkt hvor små endringer introduserer uforutsigbare konsekvenser og følgefeil. Dette var håndterbart så lenge han jobbet alene, men er ikke bærekraftig når flere utviklere skal inn.

Prosjektet er derfor modent for å gå fra solo-eksperiment til en strukturert, DevOps-orientert utviklingsprosess. Kodebasen må gjøres samarbeidsklar, arkitekturen må tydeliggjøres, og det må etableres felles arbeidsmåter for versjonskontroll, kodegjennomgang, testing og dokumentasjon. I tillegg må det settes opp CI/CD-pipelines som sikrer repeterbare, automatiserte og trygge deploys.

Dette er nødvendig for at flere utviklere skal kunne arbeide effektivt i samme kodebase, og for at løsningen skal kunne skaleres trygt i møte med både kunder og investorer.

## Oppgaven

Din oppgave er å sette utviklingsteamet i stand til å skalere virksomheten ved å ta i bruk sentrale DevOps-prinsipper. Dette innebærer å etablere en helhetlig og robust leveransemodell med fokus på automatisering, kontinuerlig integrasjon og utrulling (CI/CD), infrastruktur som kode (IaC), samt systemer for overvåking og observabilitet.

## Krav til levering i Wiseflow

**GitHub**:
* Kopier  innholdet i Eksamens-repoet til et nytt du selv oppretter. **Ikke lag en fork av det opprinnelige repositoryet.**
* For å unngå at andre studenter ser din besvarelse, kan du gjerne jobbe i et privat repository. Gjør repositoryet offentlig rett før innleveringsfristen.
* I repositoryet ditt skal du lage en fil, `README_SVAR.md` for å besvare drøfte-oppgaver og oppgavespesifikke leveranser.

**Wiseflow:**
* Når du leverer oppgaven i WiseFlow, last opp et dokument som kun inneholder en lenke til ditt repository. Filen må være i PDF- eller tekstformat.


Hvis du velger å ikke svare på enkeltoppgaver, setter også sensor stor pris på at du nevner dette i besvarelsen.

### Oppgavespesifikke leveranser

I hver oppgave vil det være en eller flere konkrete leveranser. 
Dette kan for eksempel være lenker til en GitHub Actions workflow-kjøringer, et objekt i en S3 bucket osv. 
Dette er for å gjøre sensur mer effektivt. 

**Pass på at du i ditt `README_SVAR.md` dokument får med deg alle leveranser**

## Utviklingsmiljø - GitHub Codespaces

Du kan jobbe med oppgaven i GitHub Codespaces, som gir deg et komplett utviklingsmiljø i nettleseren med alle nødvendige verktøy forhåndsinstallert (Python, SAM CLI, Terraform, Docker, AWS CLI, osv.).

**Viktig informasjon om Codespaces:**
- GitHub tilbyr 120 timer gratis Codespaces-bruk per måned for personlige kontoer
- Hvis du bruker Codespaces til andre formål (egne prosjekter, andre fag), anbefaler vi at du begrenser bruken til kun eksamensarbeid i eksamensperioden
- Husk å stoppe eller slette Codespaces når du ikke jobber aktivt for å spare timer
- Alternativt kan du jobbe lokalt på din egen maskin hvis du har utviklingsverktøyene installert

Ved tekniske problemer med miljø under eksamen, kontakt lærer. Du står naturligvis fritt til å utvikle på egen maskin.

# Evaluering

- Oppgave 1. 15 Poeng. Terraform, S3 og Infrastruktur som Kode
- Oppgave 2. 25 Poeng. AWS Lambda, SAM og GitHub Actions
- Oppgave 3. 25 Poeng. Containere og Docker
- Oppgave 4. 25 Poeng. Metrics, Observability og CloudWatch
- Oppgave 5. 10 Poeng. Drøfteoppgave - DevOps-prinsipper
- 
**Eksamensoppgaven, kode og nødvendige filer er tilgjengelig i GitHub-repoet:**
  [https://github.com/glennbechdevops/pgr301-eksamen-2025](https://github.com/glennbechdevops/pgr301-eksamen-2025).

**Oppgaveteksten ligger her:**
 [https://github.com/glennbechdevops/pgr301-eksamen-2025/README_OPPGAVER.md](https://github.com/glennbechdevops/pgr301-eksamen-2025/blob/main/README_OPPGAVER.md).


