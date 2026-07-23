-- Seed Designation Rank Codes in hrims.hr_designations
BEGIN
   EXECUTE IMMEDIATE 'CREATE TABLE hrims.hr_designations (designation VARCHAR2(100) PRIMARY KEY, desigcode NUMBER)';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -955 THEN
         RAISE;
      END IF;
END;
/

MERGE INTO hrims.hr_designations d
USING (
    SELECT 'Sc H' AS designation, 10 AS desigcode FROM DUAL UNION ALL
    SELECT 'Sc G' AS designation, 20 AS desigcode FROM DUAL UNION ALL
    SELECT 'Sc F' AS designation, 30 AS desigcode FROM DUAL
) s
ON (d.designation = s.designation)
WHEN MATCHED THEN UPDATE SET d.desigcode = s.desigcode
WHEN NOT MATCHED THEN INSERT (designation, desigcode) VALUES (s.designation, s.desigcode);

-- Seed Senior Officers (Sc F, Sc G, Sc H) in hrdata.empdetails
MERGE INTO hrdata.empdetails e
USING (
    SELECT '9001' AS PCNO, 'Dr. A. K. Sharma' AS NAME, 'Sc H' AS DESIGNATION, 'DKRM/ITISG' AS DIVNAME FROM DUAL UNION ALL
    SELECT '9002' AS PCNO, 'Smt. Sunita Rao' AS NAME, 'Sc G' AS DESIGNATION, 'DKRM/MAINT' AS DIVNAME FROM DUAL UNION ALL
    SELECT '9003' AS PCNO, 'Shri V. K. Gupta' AS NAME, 'Sc F' AS DESIGNATION, 'DKRM' AS DIVNAME FROM DUAL UNION ALL
    SELECT '9004' AS PCNO, 'Dr. Ramesh Chandra' AS NAME, 'Sc H' AS DESIGNATION, 'D-ADMIN/STORE' AS DIVNAME FROM DUAL UNION ALL
    SELECT '9005' AS PCNO, 'Shri P. K. Verma' AS NAME, 'Sc G' AS DESIGNATION, 'D-ADMIN' AS DIVNAME FROM DUAL
) s
ON (e.PCNO = s.PCNO)
WHEN MATCHED THEN UPDATE SET e.NAME = s.NAME, e.DESIGNATION = s.DESIGNATION, e.DIVNAME = s.DIVNAME
WHEN NOT MATCHED THEN INSERT (PCNO, NAME, DESIGNATION, DIVNAME) VALUES (s.PCNO, s.NAME, s.DESIGNATION, s.DIVNAME);

COMMIT;
