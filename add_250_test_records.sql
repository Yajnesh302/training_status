SET DEFINE OFF;

DECLARE
    v_first_names DBMS_SQL.VARCHAR2_TABLE;
    v_last_names DBMS_SQL.VARCHAR2_TABLE;
    v_courses DBMS_SQL.VARCHAR2_TABLE;
    v_types DBMS_SQL.VARCHAR2_TABLE;
    v_fn_count NUMBER := 10;
    v_ln_count NUMBER := 10;
    v_c_count NUMBER := 12;
    v_t_count NUMBER := 4;
    
    v_pcno VARCHAR2(50);
    v_name VARCHAR2(200);
    v_course VARCHAR2(4000);
    v_type VARCHAR2(100);
    v_cat NUMBER;
    v_status NUMBER;
    v_start DATE;
    v_end DATE;
BEGIN
    -- Names seed
    v_first_names(1) := 'Rajesh';
    v_first_names(2) := 'Priya';
    v_first_names(3) := 'Amit';
    v_first_names(4) := 'Suresh';
    v_first_names(5) := 'Ananya';
    v_first_names(6) := 'Vikram';
    v_first_names(7) := 'Kavita';
    v_first_names(8) := 'Rohan';
    v_first_names(9) := 'Deepak';
    v_first_names(10) := 'Meena';

    v_last_names(1) := 'Kumar';
    v_last_names(2) := 'Sharma';
    v_last_names(3) := 'Verma';
    v_last_names(4) := 'Nair';
    v_last_names(5) := 'Rao';
    v_last_names(6) := 'Patel';
    v_last_names(7) := 'Singh';
    v_last_names(8) := 'Gupta';
    v_last_names(9) := 'Joshi';
    v_last_names(10) := 'Reddy';

    -- Courses seed
    v_courses(1) := 'Advanced Radar Signal Processing and Systems';
    v_courses(2) := 'Phased Array Antenna Design and Integration';
    v_courses(3) := 'Embedded Systems Design using FPGA and C++';
    v_courses(4) := 'Cyber Security and Network Defense Systems';
    v_courses(5) := 'Project Management Professional (PMP) Training';
    v_courses(6) := 'Python for Data Science and Machine Learning';
    v_courses(7) := 'RF and Microwave Component Engineering';
    v_courses(8) := 'Digital Signal Processing (DSP) Architectures';
    v_courses(9) := 'Technical Report Writing and Documentation';
    v_courses(10) := 'Leadership and Strategic Management Workshop';
    v_courses(11) := 'Industrial Safety and Compliance Protocols';
    v_courses(12) := 'Deep Learning for Image and Audio Processing';

    -- Types seed
    v_types(1) := 'Internal';
    v_types(2) := 'External';
    v_types(3) := 'Workshop';
    v_types(4) := 'Seminar';

    -- Loop to insert 250 test records
    FOR i IN 1..250 LOOP
        v_pcno := TO_CHAR(1000 + i);
        v_name := v_first_names(MOD(i, v_fn_count) + 1) || ' ' || v_last_names(MOD(TRUNC(i/2), v_ln_count) + 1);
        v_course := v_courses(MOD(i, v_c_count) + 1);
        v_type := v_types(MOD(i, v_t_count) + 1);
        v_cat := MOD(i, 5) + 1;
        v_status := MOD(i, 5) + 1;
        v_start := DATE '2026-01-01' + MOD(i * 3, 180);
        v_end := v_start + MOD(i, 7) + 1;

        -- Insert or ignore employee details
        BEGIN
            INSERT INTO hrdata.empdetails (PCNO, NAME, DESIGNATION, DIVNAME)
            VALUES (v_pcno, v_name, 'Scientist ' || CHR(65 + MOD(i, 4)), 'ITISG');
        EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN NULL;
        END;

        -- Insert training record
        INSERT INTO hrims.bkup_hr_emp_training_21jul2026 (
            PCNO, CTRTRAINING, COURSETYPE, COURSENAME, ORGANIZER, VENUE,
            STARTDATE, ENDDATE, NOOFDAYS, FEE, FEESOURCE, PREDRDO, DOPARTREF,
            COURSE_CATEGORY, CITY, SYS_ENTRY_DATE, TRAINING_STATUS
        ) VALUES (
            v_pcno, 'TRG-' || TO_CHAR(202600 + i), v_type, v_course, 'DIAT / DRDO', 'Bengaluru',
            v_start, v_end, (v_end - v_start), 15000, 'Govt', 'No', 'DO-PART-' || i,
            v_cat, 'Bengaluru', SYSDATE, v_status
        );
    END LOOP;

    COMMIT;
END;
/
EXIT;
