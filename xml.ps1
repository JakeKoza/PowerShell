function SponsorInformationGroup{
    $XmlGroupSponserInfo = $xml.myFields.AppendChild($xml.CreateElement("SponsorInformation"))
 
    $mkSponserDeadline = $XmlGroupSponserInfo.AppendChild($xml.CreateElement("SponserDeadline"))
    $mvSponserDeadline = $mkSponserDeadline.AppendChild($xml.CreateTextNode($xml.myFields.SponserDeadline));

    $mkSponserDeadlineType = $XmlGroupSponserInfo.AppendChild($xml.CreateElement("SponsorDeadlineType"))
    $mvSponserDeadlineType = $mkSponserDeadlineType.AppendChild($xml.CreateTextNode($xml.myFields.SponsorDeadlineType))

    $mkSubmissionType = $XmlGroupSponserInfo.AppendChild($xml.CreateElement("SubmissionType"))
    $mvSubmissionType = $mkSubmissionType.AppendChild($xml.CreateTextNode($xml.myFields.SubmissionType))

    $mkSubmissionTypeSite = $XmlGroupSponserInfo.AppendChild($xml.CreateElement("SubmissionTypeSite"))
    $mvSubmissionTypeSite = $mkSubmissionTypeSite.AppendChild($xml.CreateTextNode($xml.myFields.SubmissionTypeSite))

    $mkSponsorName = $XmlGroupSponserInfo.AppendChild($xml.CreateElement("SponsorName"))
    $mvSponsorName = $mkSponsorName.AppendChild($xml.CreateTextNode($xml.myFields.SponsorName))

    $mkSponsorDivision = $XmlGroupSponserInfo.AppendChild($xml.CreateElement("SponsorDivision"))
    $mvSponsorDivision = $mkSponsorDivision.AppendChild($xml.CreateTextNode($xml.myFields.SponsorDivision))

    $mkSponsorType = $XmlGroupSponserInfo.AppendChild($xml.CreateElement("SponsorType"))
    $mvSponsorType = $mkSponsorType.AppendChild($xml.CreateTextNode($xml.myFields.SponsorType))

    $mkCFDA = $XmlGroupSponserInfo.AppendChild($xml.CreateElement("CFDANumber"))
    $mvCFDA = $mkCFDA.AppendChild($xml.CreateTextNode($xml.myFields.CFDANumber))
}
function InvestigatorInformationGroup{}
function BudgetInformationGroup{}
function ComplianceRequirementsGroup{}
function AttachmentsGroup{}
function ApprovalsGroup{}
function CleanUp{

}

$path = "C:\Users\n00974115\Documents\PowershellTest.xml"
$xml = [xml](get-content $path)

$xml.myFields

SponsorInformationGroup

$xml.myFields
$xml.myFields.SponsorInformation |ft



