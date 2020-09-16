SELECT DISTINCT
       -- c.ClientID,
       -- c.ClientName,
       -- c.ClientNumber,
       -- ai.AssociateID,
       ai.LegalFormattedName AS name,
       FLOOR(DATEDIFF(SYSDATE(), ai.BirthDate) / 365) AS age,
       -- now() - ai.BirthDate,
       -- ai.BusinessEmailAddress,
       -- ai.BusinessMobileFormattedNumber,
       -- p.PositionID,
       -- p.PositionName,
       -- p.PositionNumber,
       -- j.JobID,
       j.JobName AS position,
       -- loc.LocationID,
       loc.LocationName as location,
       -- loc.LocationNumber,
       -- loc.Country_Code work_country,
       -- loc.Context_Country_Code,
       -- cp.CompensationPackageID,
       cp.CompensationAmount AS salary
       -- cp.Currency_Code
       -- CASE WHERN 
       -- cp.EarningFrequency_Code,
       -- cp.PercentageIndicator,
       -- cp.CompensationUnit_Code,
       -- ce.CompensationElementName,
       -- agr.IssuingAuthorityID,
       -- agr.IssueDate,
    -- agr.ExpirationDate,
       -- d.DocumentID,
       -- d.Context_Country_Code,
       -- d.DocumentCategory_Code,
       -- d.DocumentSubCategory_Code
       -- ia.IssuingAuthorityName
  FROM Client c
  JOIN Associate a ON (a.ClientID = c.ClientID)
  JOIN AssociateIndicative ai ON (ai.ClientID = c.ClientID AND ai.AssociateID = a.AssociateID)
  JOIN WorkAgreement wag ON (wag.AssociateID = a.AssociateID)
  JOIN WorkAssignment was ON (was.WorkAgreementID = wag.WorkAgreementID)
  JOIN WorkAssignmentLocation wal ON (wal.WorkAssignmentID = was.WorkAssignmentID)
  JOIN Location loc ON (loc.LocationID = wal.LocationID)
  JOIN Position p ON (p.PositionID = was.PositionID)
  JOIN Job j ON (j.JobID = p.JobID)
  JOIN CompensationPackage cp ON (cp.WorkAssignmentID = was.WorkAssignmentID)
  JOIN CompensationElement ce ON (ce.CompensationElementID = cp.CompensationElementID AND ce.CompensationElementName = 'Regular Pay')
  JOIN CompensationElementType cet ON (cet.CompensationElementTypeID = ce.CompensationElementTypeID)
  JOIN AssociateGovernmentRegistration agr ON (agr.AssociateID = a.AssociateID)
  JOIN Document d ON (d.DocumentID = agr.DocumentID)
  JOIN IssuingAuthority ia ON (ia.IssuingAuthorityID = agr.IssuingAuthorityID)
 WHERE c.ClientID = '1ee1ee51-3235-11e6-a564-005056b06f29'
   AND cp.CompensationUnit_Code = 'cash'
   AND ce.CompensationElementName IN ('Regular Pay')
   AND d.DocumentCategory_Code = 'GovernmentRegistration'
   AND was._ValidityEndDateTime > NOW()
   AND wag._ValidityEndDateTime > NOW()
 LIMIT 300;