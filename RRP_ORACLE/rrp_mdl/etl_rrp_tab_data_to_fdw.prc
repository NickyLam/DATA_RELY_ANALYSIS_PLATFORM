CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_RRP_TAB_DATA_TO_FDW
(
  I_P_DATE IN INTEGER, --跑批日期
  O_RETURN_CODE OUT VARCHAR2 --断点续跑时，用于识别存储过程的是否跳过1--跳过 0--不跳过
)
/******************************
 **  存储过程详细说明：监管报送供数给财务集市明细表
    **  存储过程名称:  ETL_RRP_TAB_DATA_TO_FDW
    **  存储过程创建日期:2022-08-05
    **  存储过程创建人:MW
    **  修改日期          修改项目             修改原因                           修改人
  *******************************/
 IS
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(100) := 'ETL_RRP_TAB_DATA_TO_FDW'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(30); -- 来源系统
  V_LAST_DAT  VARCHAR2(8); -- 当月月末
  V_YESTADAY  VARCHAR2(8); -- 上日
  V_MONTH_START_DATE DATE;  --系统时间对应月初日期
  V_STEP_DESC VARCHAR2(200); --任务名称
  DATA_DATE  CHAR(8);
BEGIN
    V_P_DATE := TO_CHAR(I_P_DATE);
    V_SYSTEM := '监管报送';
    V_YESTADAY := TO_CHAR(TO_DATE(V_P_DATE,'YYYYMMDD')-1,'YYYYMMDD'); -- 上日
    V_LAST_DAT := TO_CHAR(LAST_DAY(TO_DATE(V_P_DATE,'YYYY-MM-DD')),'YYYYMMDD'); --当月月底
  V_MONTH_START_DATE := TRUNC(TO_DATE(I_P_DATE,'YYYYMMDD'), 'MM');

  DATA_DATE := TO_CHAR(V_MONTH_START_DATE-1,'YYYYMMDD');



-- 支持重跑 --
   V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
 -- DELETE FROM RRP_TAB_DATA_TO_FDW T WHERE T.REPORT_DATE = V_P_DATE;--普通表的重跑处理

  /*EXECUTE IMMEDIATE ('ALTER TABLE '||'TAB_DATA_TO_FDW'||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理*/
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_RETURN_CODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_RETURN_CODE,V_SQLMSG);


    EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_TAB_DATA_TO_FDW';


  V_STEP := V_STEP + 1;
  V_STEP_DESC := '监管报送供数给财务集市明细表--插入CBRC报表';
  V_STARTTIME := SYSDATE;
/*INSERT \*+APPEND PARALLEL*\ INTO RRP_TAB_DATA_TO_FDW
SELECT '00002','1104法人报送',S.ORG_NO,S.ORG_NM,S.UP_ORG_ID,S.UP_ORG_NAME,S.DATA_DATE,S.RPT_NO,
CASE S.RPT_NO WHEN 'G22' THEN 'G22_流动性比例监测表'
                 WHEN 'G01' THEN 'G01_资产负债项目统计表'
                 WHEN 'G03' THEN 'G03_各项资产减值损失准备情况表'
                 WHEN 'G15' THEN 'G15_最大十家关联方关联交易情况表'
                 WHEN 'G0102' THEN 'G0102_资产负债项目统计表附注'
                 WHEN 'G0103' THEN 'G0103_资产负债项目统计表附注'
                 WHEN 'G0107' THEN 'G0107_贷款分行业情况表'
                 WHEN 'G2501' THEN 'G2501_流动性覆盖率和净稳定资金比例情况表'
                 WHEN 'S6301' THEN 'S6301_大中小微型企业贷款情况表'
                 ELSE S.RPT_NO
                 END
       ,NULL,NULL,S.CURRENCY,S.INDEX_NO,NULL,S.INDEX_VAL,V_P_DATE,'AUDITPASS'
FROM
(
SELECT \* PARALLEL*\ * FROM
(
   SELECT \* PARALLEL*\ A.*,B.ORG_NM  ORG_NM,B.UP_ORG_ID UP_ORG_ID,C.ORG_NM UP_ORG_NAME,
          ROW_NUMBER() OVER(PARTITION BY A.INDEX_NO, A.ORG_NO, A.CURRENCY, A.DATA_DATE ORDER BY A.DATA_DATE DESC) RN
     FROM RRP_IND.RPT_CBRC_RESULT A

     LEFT JOIN M_PUM_ORG_INFO B
     ON A.ORG_NO = B.ORG_ID
     AND B.DATA_DT = V_P_DATE
     LEFT JOIN M_PUM_ORG_INFO C
     ON B.UP_ORG_ID = C.ORG_ID
     AND C.DATA_DT = V_P_DATE
   WHERE A.RPT_NO IN ( 'G2501',
                          'G2502',
                          'G40',
                          'G44',
                          'S6301',
                          'A1411',
                          'G0102',
                          'G0103',
                          'G0107',
                          'G01',
                          'G03',
                          'G4A',
                          'G15',
                          'G22')
    AND A.ORG_NO = '00000V1'  --只取总行
      AND A.DATA_DATE =  V_P_DATE --取上月末报表日期
)
WHERE RN = 1
) S;
COMMIT;

 V_STEP := V_STEP + 1;
  V_STEP_DESC := '监管报送供数给财务集市明细表--插入PBOC报表';
  V_STARTTIME := SYSDATE;
INSERT \*+APPEND PARALLEL*\ INTO RRP_TAB_DATA_TO_FDW
SELECT '00001','大集中报送',S.ORG_NO,S.ORG_NM,S.UP_ORG_ID,S.UP_ORG_NAME,S.DATA_DATE,S.RPT_NO,
CASE S.RPT_NO WHEN 'G22' THEN 'G22_流动性比例监测表'
                 WHEN 'G01' THEN 'G01_资产负债项目统计表'
                 WHEN 'G03' THEN 'G03_各项资产减值损失准备情况表'
                 WHEN 'G15' THEN 'G15_最大十家关联方关联交易情况表'
                 WHEN 'G0102' THEN 'G0102_资产负债项目统计表附注'
                 WHEN 'G0103' THEN 'G0103_资产负债项目统计表附注'
                 WHEN 'G0107' THEN 'G0107_贷款分行业情况表'
                 WHEN 'G2501' THEN 'G2501_流动性覆盖率和净稳定资金比例情况表'
                 WHEN 'S6301' THEN 'S6301_大中小微型企业贷款情况表'
                 WHEN 'A1411' THEN 'A1411_金融机构资产负债项目月报表'
                 ELSE S.RPT_NO
                 END
       ,NULL,NULL,S.CURRENCY,S.INDEX_NO,NULL,S.INDEX_VAL,V_P_DATE,'AUDITPASS'
FROM
(
SELECT \* PARALLEL*\ * FROM
(
   SELECT \* PARALLEL*\ A.*,B.ORG_NM  ORG_NM,B.UP_ORG_ID UP_ORG_ID,C.ORG_NM UP_ORG_NAME,
          ROW_NUMBER() OVER(PARTITION BY A.INDEX_NO, A.ORG_NO, A.CURRENCY, A.DATA_DATE ORDER BY A.DATA_DATE DESC) RN
     FROM RRP_IND.RPT_CBRC_RESULT A
     LEFT JOIN M_PUM_ORG_INFO B
     ON A.ORG_NO = B.ORG_ID
     AND B.DATA_DT = V_P_DATE
     LEFT JOIN M_PUM_ORG_INFO C
     ON B.UP_ORG_ID = C.ORG_ID
     AND C.DATA_DT = V_P_DATE
   WHERE A.RPT_NO IN ( 'G2501',
                          'G2502',
                          'G40',
                          'G44',
                          'S6301',
                          'A1411',
                          'G0102',
                          'G0103',
                          'G0107',
                          'G01',
                          'G03',
                          'G4A',
                          'G15',
                          'G22')
    AND A.ORG_NO = '00000V1'  --只取总行
      AND A.DATA_DATE =  V_P_DATE --取上月末报表日期
)
WHERE RN = 1
) S;*/
--01--G22
--01--G22
INSERT INTO RRP_TAB_DATA_TO_FDW
(sys_no
,sys_str
,org_num
,org_name
,up_org_num
,up_org_name
,report_date
,report_id
,report_name
,report_caliber
,report_freq
,curr_code
,index_id
,index_str
,index_iv
,etl_date
,status_id
)
SELECT
'00002',
'1104法人报送',
'00000V1',
'广东省',
'000000',
'广东华兴银行股份有限公司'
,TO_CHAR(TO_DATE(t.DATA_DATE,'YYYYMMDD'),'YYYY-MM-DD')
,'G22',
'G22流动性比例监测表',
'G22.2018.01.01',
'M-月',
null,
NVL(CASE WHEN LENGTH(REPLACE(REPLACE(T1.TAR_INDEX_NO,'_','.'),'G2200.','G22_')) <=8
  THEN REPLACE(REPLACE(REPLACE(T1.TAR_INDEX_NO,'_','.'),'G2200.','G22_'),'.','..')
  ELSE REPLACE(REPLACE(T1.TAR_INDEX_NO,'_','.'),'G2200.','G22_')
  END,T.INDEX_NO) ,
NULL,
T.INDEX_VAL,
t.DATA_DATE,
'auditPass'
FROM RRP_PLAT.RPT_REPORT_RESULT@LINK_RRP T
LEFT JOIN ADD_INDEX_MAP T1
     ON T1.SRC_INDEX_NO = T.INDEX_NO
WHERE T.DATA_DATE = DATA_DATE
AND SUBSTR(T.INDEX_NO,1,5) = 'G2200'
AND T.ORG_NO = '00000V1';
COMMIT;

------------
--02--G03
INSERT INTO RRP_TAB_DATA_TO_FDW
(sys_no
,sys_str
,org_num
,org_name
,up_org_num
,up_org_name
,report_date
,report_id
,report_name
,report_caliber
,report_freq
,curr_code
,index_id
,index_str
,index_iv
,etl_date
,status_id
)
SELECT
'00002',
'1104法人报送',
'00000V1',
'广东省',
'000000',
'广东华兴银行股份有限公司'
,TO_CHAR(TO_DATE(t.DATA_DATE,'YYYYMMDD'),'YYYY-MM-DD'),
'G03',
'G03各项资产减值损失准备情况表',
'G03.2019.01.01',
'M_月',
null,
NVL(T1.TAR_INDEX_NO,T.INDEX_NO),
NULL,
T.INDEX_VAL,
T.DATA_DATE,
'auditPass'
FROM RRP_PLAT.RPT_REPORT_RESULT@LINK_RRP T
LEFT JOIN ADD_INDEX_MAP T1
     ON T1.SRC_INDEX_NO = T.INDEX_NO
WHERE T.DATA_DATE = DATA_DATE
AND SUBSTR(T.INDEX_NO,1,5) = 'G0300'
AND T.ORG_NO = '00000V1';
COMMIT;
--
--03 --G01
INSERT INTO RRP_TAB_DATA_TO_FDW
(sys_no
,sys_str
,org_num
,org_name
,up_org_num
,up_org_name
,report_date
,report_id
,report_name
,report_caliber
,report_freq
,curr_code
,index_id
,index_str
,index_iv
,etl_date
,status_id
)
SELECT
'00002',
'1104法人报送',
'00000V1',
'广东省',
'000000',
'广东华兴银行股份有限公司',
TO_CHAR(TO_DATE(t.DATA_DATE,'YYYYMMDD'),'YYYY-MM-DD'),
'G01',
'G01资产负债项目统计表',
'G01.2021.01.01',
'M_月',
null,
NVL(T1.TAR_INDEX_NO,T.INDEX_NO),
NULL,
T.INDEX_VAL,
T.DATA_DATE,
'auditPass'
FROM RRP_PLAT.RPT_REPORT_RESULT@LINK_RRP T
LEFT JOIN ADD_INDEX_MAP T1
     ON T1.SRC_INDEX_NO = T.INDEX_NO
WHERE T.DATA_DATE = DATA_DATE
AND SUBSTR(T.INDEX_NO,1,5) = 'G0100'
AND T.ORG_NO = '00000V1';
COMMIT;

-----
--04   --G2502
INSERT INTO RRP_TAB_DATA_TO_FDW
(sys_no
,sys_str
,org_num
,org_name
,up_org_num
,up_org_name
,report_date
,report_id
,report_name
,report_caliber
,report_freq
,curr_code
,index_id
,index_str
,index_iv
,etl_date
,status_id
)
SELECT
'00002',
'1104法人报送',
'00000V1',
'广东省',
'000000',
'广东华兴银行股份有限公司',
TO_CHAR(TO_DATE(t.DATA_DATE,'YYYYMMDD'),'YYYY-MM-DD'),
'G25_2',
'G25_2净稳定资金比率',
'G25_2.2020.01.01',
'Q-季',
null,
NVL(REPLACE(REPLACE(CASE WHEN LENGTH(REPLACE(REPLACE(T1.TAR_INDEX_NO,'_','.'),'G2502.','G25_2.')) <=10
  THEN REPLACE(REPLACE(REPLACE(T1.TAR_INDEX_NO,'_','.'),'G2502.','G25_2.'),'.','..')
  ELSE REPLACE(REPLACE(T1.TAR_INDEX_NO,'_','.'),'G2502.','G25_2.')
  END,'.II','_2'),'.I','_1' ),T.INDEX_NO),
NULL,
T.INDEX_VAL,
t.DATA_DATE,
'auditPass'
FROM RRP_PLAT.RPT_REPORT_RESULT@LINK_RRP T
LEFT JOIN ADD_INDEX_MAP T1
     ON T1.SRC_INDEX_NO = T.INDEX_NO
WHERE T.DATA_DATE = DATA_DATE
AND SUBSTR(T.INDEX_NO,1,5) = 'G2502'
AND T.ORG_NO = '00000V1';
COMMIT;


--05 G2501

INSERT INTO RRP_TAB_DATA_TO_FDW
(sys_no
,sys_str
,org_num
,org_name
,up_org_num
,up_org_name
,report_date
,report_id
,report_name
,report_caliber
,report_freq
,curr_code
,index_id
,index_str
,index_iv
,etl_date
,status_id
)
SELECT
'00002',
'1104法人报送',
'00000V1',
'广东省',
'000000',
'广东华兴银行股份有限公司',
TO_CHAR(TO_DATE(t.DATA_DATE,'YYYYMMDD'),'YYYY-MM-DD'),
'G25_1',
'G25_1流动性覆盖率和净稳定资金比例情况表',
'G25_1.2018.01.01',
'M-月',
null,
NVL(T1.TAR_INDEX_NO,T.INDEX_NO),
NULL,
T.INDEX_VAL,
t.DATA_DATE,
'auditPass'
FROM RRP_PLAT.RPT_REPORT_RESULT@LINK_RRP T
LEFT JOIN ADD_INDEX_MAP T1
     ON T1.SRC_INDEX_NO = T.INDEX_NO
WHERE T.DATA_DATE = DATA_DATE
AND SUBSTR(T.INDEX_NO,1,5) = 'G2501'
AND T.ORG_NO = '00000V1';
COMMIT;
--06 G0103
INSERT INTO RRP_TAB_DATA_TO_FDW
(sys_no
,sys_str
,org_num
,org_name
,up_org_num
,up_org_name
,report_date
,report_id
,report_name
,report_caliber
,report_freq
,curr_code
,index_id
,index_str
,index_iv
,etl_date
,status_id
)
SELECT
'00002',
'1104法人报送',
'00000V1',
'广东省',
'000000',
'广东华兴银行股份有限公司',
TO_CHAR(TO_DATE(t.DATA_DATE,'YYYYMMDD'),'YYYY-MM-DD'),
'G01_3',
'G01资产负债项目统计表附注3',
'G01_3.2022.01.01',
'M_月',
null,
NVL(T1.TAR_INDEX_NO,T.INDEX_NO),
NULL,
T.INDEX_VAL,
T.DATA_DATE,
'auditPass'
FROM RRP_PLAT.RPT_REPORT_RESULT@LINK_RRP T
LEFT JOIN ADD_INDEX_MAP T1
     ON T1.SRC_INDEX_NO = T.INDEX_NO
WHERE T.DATA_DATE = DATA_DATE
AND SUBSTR(T.INDEX_NO,1,5) = 'G0103'
AND T.ORG_NO = '00000V1';
COMMIT;
--07  --G40
INSERT INTO RRP_TAB_DATA_TO_FDW
(sys_no
,sys_str
,org_num
,org_name
,up_org_num
,up_org_name
,report_date
,report_id
,report_name
,report_caliber
,report_freq
,curr_code
,index_id
,index_str
,index_iv
,etl_date
,status_id
)
SELECT
'00002',
'1104法人报送',
'00000V1',
'广东省',
'000000',
'广东华兴银行股份有限公司',
TO_CHAR(TO_DATE(t.DATA_DATE,'YYYYMMDD'),'YYYY-MM-DD'),
'G40',
'G40资本充足率汇总表',
'G40.2014.01.01',
'Q-季',
null,
NVL(CASE WHEN LENGTH(REPLACE(REPLACE(T1.TAR_INDEX_NO,'_','.'),'G4000.','G40_')) <=8
  THEN REPLACE(REPLACE(REPLACE(T1.TAR_INDEX_NO,'_','.'),'G4000.','G40_'),'.','..')
  ELSE REPLACE(REPLACE(T1.TAR_INDEX_NO,'_','.'),'G4000.','G40_')
  END,T.INDEX_NO),
NULL,
T.INDEX_VAL,
t.DATA_DATE,
'auditPass'
FROM RRP_PLAT.RPT_REPORT_RESULT@LINK_RRP T
LEFT JOIN ADD_INDEX_MAP T1
     ON T1.SRC_INDEX_NO = T.INDEX_NO
WHERE T.DATA_DATE = DATA_DATE
AND SUBSTR(T.INDEX_NO,1,5) = 'G4000'
AND T.ORG_NO = '00000V1';

COMMIT;
--08 G44
INSERT INTO RRP_TAB_DATA_TO_FDW
(sys_no
,sys_str
,org_num
,org_name
,up_org_num
,up_org_name
,report_date
,report_id
,report_name
,report_caliber
,report_freq
,curr_code
,index_id
,index_str
,index_iv
,etl_date
,status_id
)
SELECT
'00002',
'1104法人报送',
'00000V1',
'广东省',
'000000',
'广东华兴银行股份有限公司',
TO_CHAR(TO_DATE(t.DATA_DATE,'YYYYMMDD'),'YYYY-MM-DD'),
'G44',
'G44杠杆率情况表',
'G44.2015.01.01',
'Q-季',
NULL,
NVL(CASE WHEN LENGTH(REPLACE(REPLACE(T1.TAR_INDEX_NO,'_','.'),'G4400.','G44_')) <=8
  THEN REPLACE(REPLACE(REPLACE(T1.TAR_INDEX_NO,'_','.'),'G4400.','G44_'),'.','..')
  ELSE REPLACE(REPLACE(T1.TAR_INDEX_NO,'_','.'),'G4400.','G44_')
  END,T.INDEX_NO),
NULL,
T.INDEX_VAL,
t.DATA_DATE,
'auditPass'
FROM RRP_PLAT.RPT_REPORT_RESULT@LINK_RRP T
LEFT JOIN ADD_INDEX_MAP T1
     ON T1.SRC_INDEX_NO = T.INDEX_NO
WHERE T.DATA_DATE = DATA_DATE
AND SUBSTR(T.INDEX_NO,1,5) = 'G4400'
AND T.ORG_NO = '00000V1';
COMMIT;
--09 G4A

INSERT INTO RRP_TAB_DATA_TO_FDW
(sys_no
,sys_str
,org_num
,org_name
,up_org_num
,up_org_name
,report_date
,report_id
,report_name
,report_caliber
,report_freq
,curr_code
,index_id
,index_str
,index_iv
,etl_date
,status_id
)
SELECT
'00002',
'1104法人报送',
'00000V1',
'广东省',
'000000',
'广东华兴银行股份有限公司',
TO_CHAR(TO_DATE(t.DATA_DATE,'YYYYMMDD'),'YYYY-MM-DD'),
'G4A',
'G4A 合格资本情况表',
'G4A.2021.01.01',
'Q-季',
null,
NVL(CASE WHEN LENGTH(REPLACE(REPLACE(T1.TAR_INDEX_NO,'_','.'),'G4A00.','G4A_00_')) <=11
  THEN REPLACE(REPLACE(REPLACE(T1.TAR_INDEX_NO,'_','.'),'G4A00.','G4A_00_'),'.','..')
  ELSE REPLACE(REPLACE(T1.TAR_INDEX_NO,'_','.'),'G4A00.','G4A_00_')
  END,T.INDEX_NO),
NULL,
T.INDEX_VAL,
t.DATA_DATE,
'auditPass'
FROM RRP_PLAT.RPT_REPORT_RESULT@LINK_RRP T
LEFT JOIN ADD_INDEX_MAP T1
     ON T1.SRC_INDEX_NO = T.INDEX_NO
WHERE T.DATA_DATE = DATA_DATE
AND SUBSTR(T.INDEX_NO,1,5) = 'G4A00'
AND T.ORG_NO = '00000V1';

COMMIT;
--10 S6301

INSERT INTO RRP_TAB_DATA_TO_FDW
(sys_no
,sys_str
,org_num
,org_name
,up_org_num
,up_org_name
,report_date
,report_id
,report_name
,report_caliber
,report_freq
,curr_code
,index_id
,index_str
,index_iv
,etl_date
,status_id
)
SELECT
'00002',
'1104法人报送',
'00000V1',
'广东省',
'000000',
'广东华兴银行股份有限公司',
TO_CHAR(TO_DATE(t.DATA_DATE,'YYYYMMDD'),'YYYY-MM-DD'),
'S63_I',
'S63_I大中小微型企业贷款情况表',
'S63_I.2022.01.01',
'M-月',
null,
NVL(T1.TAR_INDEX_NO,T.INDEX_NO),
NULL,
T.INDEX_VAL,
t.DATA_DATE,
'auditPass'
FROM RRP_PLAT.RPT_REPORT_RESULT@LINK_RRP T
LEFT JOIN ADD_INDEX_MAP T1
     ON T1.SRC_INDEX_NO = T.INDEX_NO
WHERE T.DATA_DATE = DATA_DATE
AND SUBSTR(T.INDEX_NO,1,5) = 'S6301'
AND T.ORG_NO = '00000V1';
COMMIT;

--11 A1411

INSERT INTO RRP_TAB_DATA_TO_FDW
(sys_no
,sys_str
,org_num
,org_name
,up_org_num
,up_org_name
,report_date
,report_id
,report_name
,report_caliber
,report_freq
,curr_code
,index_id
,index_str
,index_iv
,etl_date
,status_id
)
SELECT
'00002',
'1104法人报送',
'00000V1',
'广东省',
'000000',
'广东华兴银行股份有限公司',
TO_CHAR(TO_DATE(t.DATA_DATE,'YYYYMMDD'),'YYYY-MM-DD'),
'A1411',
'A1411_金融机构资产负债项目月报表',
'A1411.2022.01.01',
'M-月',
null,
NVL(T1.TAR_INDEX_NO,T.INDEX_NO),
NULL,
T.INDEX_VAL,
t.DATA_DATE,
'auditPass'
FROM RRP_PLAT.RPT_REPORT_RESULT@LINK_RRP T
LEFT JOIN ADD_INDEX_MAP T1
     ON T1.SRC_INDEX_NO = T.INDEX_NO
WHERE T.DATA_DATE = DATA_DATE
AND SUBSTR(T.INDEX_NO,1,5) = 'A1411'
AND T.ORG_NO = '00000V1';
COMMIT;
--12 G0102

INSERT INTO RRP_TAB_DATA_TO_FDW
(sys_no
,sys_str
,org_num
,org_name
,up_org_num
,up_org_name
,report_date
,report_id
,report_name
,report_caliber
,report_freq
,curr_code
,index_id
,index_str
,index_iv
,etl_date
,status_id
)
SELECT
'00002',
'1104法人报送',
'00000V1',
'广东省',
'000000',
'广东华兴银行股份有限公司',
TO_CHAR(TO_DATE(t.DATA_DATE,'YYYYMMDD'),'YYYY-MM-DD'),
'G01_2',
'G01资产负债项目统计表附注2',
'G01_2.2020.01.01',
'M_月',
null,
NVL(T1.TAR_INDEX_NO,T.INDEX_NO),
NULL,
T.INDEX_VAL,
T.DATA_DATE,
'auditPass'
FROM RRP_PLAT.RPT_REPORT_RESULT@LINK_RRP T
LEFT JOIN ADD_INDEX_MAP T1
     ON T1.SRC_INDEX_NO = T.INDEX_NO
WHERE T.DATA_DATE = DATA_DATE
AND SUBSTR(T.INDEX_NO,1,5) = 'G0102'
AND T.ORG_NO = '00000V1';
COMMIT;
--13 G0107
INSERT INTO RRP_TAB_DATA_TO_FDW
(sys_no
,sys_str
,org_num
,org_name
,up_org_num
,up_org_name
,report_date
,report_id
,report_name
,report_caliber
,report_freq
,curr_code
,index_id
,index_str
,index_iv
,etl_date
,status_id
)
SELECT
'00002',
'1104法人报送',
'00000V1',
'广东省',
'000000',
'广东华兴银行股份有限公司',
TO_CHAR(TO_DATE(t.DATA_DATE,'YYYYMMDD'),'YYYY-MM-DD'),
'G01_7',
'G01资产负债项目统计表附注7',
'G01_7.2022.01.01',
'M_月',
null,
NVL(T1.TAR_INDEX_NO,T.INDEX_NO),
NULL,
T.INDEX_VAL,
T.DATA_DATE,
'auditPass'
FROM RRP_PLAT.RPT_REPORT_RESULT@LINK_RRP T
LEFT JOIN ADD_INDEX_MAP T1
     ON T1.SRC_INDEX_NO = T.INDEX_NO
WHERE T.DATA_DATE = DATA_DATE
AND SUBSTR(T.INDEX_NO,1,5) = 'G0107'
AND T.ORG_NO = '00000V1';
COMMIT;

--14 G15

INSERT INTO RRP_TAB_DATA_TO_FDW
(sys_no
,sys_str
,org_num
,org_name
,up_org_num
,up_org_name
,report_date
,report_id
,report_name
,report_caliber
,report_freq
,curr_code
,index_id
,index_str
,index_iv
,etl_date
,status_id
)
SELECT
'00002',
'1104法人报送',
'00000V1',
'广东省',
'000000',
'广东华兴银行股份有限公司',
TO_CHAR(TO_DATE(t.DATA_DATE,'YYYYMMDD'),'YYYY-MM-DD'),
'G15',
'G15最大十家关联方关联交易情况表',
'G15.2022.01.01',
'Q-季',
null,
NVL(T1.TAR_INDEX_NO,T.INDEX_NO),
NULL,
T.INDEX_VAL,
T.DATA_DATE,
'auditPass'
FROM RRP_PLAT.RPT_REPORT_RESULT@LINK_RRP T
LEFT JOIN ADD_INDEX_MAP T1
     ON T1.SRC_INDEX_NO = T.INDEX_NO
WHERE T.DATA_DATE = DATA_DATE
AND SUBSTR(T.INDEX_NO,1,5) = 'G1500'
AND T.ORG_NO = '00000V1';
COMMIT;

 ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_RETURN_CODE,V_SQLMSG);

V_STEP_DESC := '监管报送供数给财务集市明细表--插入跑批状态完成表';
DELETE FROM REP_TAB_DATA_TO_FDW_STATUS WHERE REPORT_DATE = TO_CHAR(TO_DATE(DATA_DATE,'YYYYMMDD'),'YYYY-MM-DD');
INSERT /*+APPEND PARALLEL*/ INTO REP_TAB_DATA_TO_FDW_STATUS 
    SELECT /* PARALLEL*/ DISTINCT A.REPORT_ID
      ,A.REPORT_NAME
      ,A.REPORT_DATE
      ,CASE WHEN A.STATUS_ID IN ('auditPass','end') THEN 'Y' ELSE 'N' END
      ,TO_TIMESTAMP(V_P_DATE, 'yyyy-mm-dd hh24:mi:ss.ff6')
        FROM RRP_TAB_DATA_TO_FDW A
    WHERE A.ETL_DATE = DATA_DATE
     ;
  COMMIT;
IF SUBSTRB(DATA_DATE,5,2) NOT IN ('03','06','09','12')
THEN
INSERT INTO  REP_TAB_DATA_TO_FDW_STATUS 
VALUES('G25_2','G25_2净稳定资金比率',TO_CHAR(TO_DATE(DATA_DATE,'YYYYMMDD'),'YYYY-MM-DD'),'Y',TO_TIMESTAMP(V_P_DATE, 'yyyy-mm-dd hh24:mi:ss.ff6'))
;
INSERT INTO  REP_TAB_DATA_TO_FDW_STATUS 
VALUES('G40','G40资本充足率汇总表',TO_CHAR(TO_DATE(DATA_DATE,'YYYYMMDD'),'YYYY-MM-DD'),'Y',TO_TIMESTAMP(V_P_DATE, 'yyyy-mm-dd hh24:mi:ss.ff6'))
;
INSERT INTO  REP_TAB_DATA_TO_FDW_STATUS 
VALUES('G44','G44杠杆率情况表',TO_CHAR(TO_DATE(DATA_DATE,'YYYYMMDD'),'YYYY-MM-DD'),'Y',TO_TIMESTAMP(V_P_DATE, 'yyyy-mm-dd hh24:mi:ss.ff6'))
;
INSERT INTO  REP_TAB_DATA_TO_FDW_STATUS 
VALUES('G15','G15最大十家关联方关联交易情况表',TO_CHAR(TO_DATE(DATA_DATE,'YYYYMMDD'),'YYYY-MM-DD'),'Y',TO_TIMESTAMP(V_P_DATE, 'yyyy-mm-dd hh24:mi:ss.ff6'))
;
INSERT INTO  REP_TAB_DATA_TO_FDW_STATUS 
VALUES('G4A','G4A合格资本情况表',TO_CHAR(TO_DATE(DATA_DATE,'YYYYMMDD'),'YYYY-MM-DD'),'Y',TO_TIMESTAMP(V_P_DATE, 'yyyy-mm-dd hh24:mi:ss.ff6'))
;
COMMIT;
END IF;
   -- 程序跑批结束记录 --
   V_STEP_DESC := '-- 程序跑批结束 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_RETURN_CODE,'');

   -- 程序异常处理部分 --
   EXCEPTION
     WHEN OTHERS THEN
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   ROLLBACK;
     O_RETURN_CODE := SQLCODE;
     V_ENDTIME := SYSDATE;
   V_STEP := V_STEP + 1;
     V_STEP_DESC := '-- 程序跑批异常 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_RETURN_CODE,V_SQLMSG);

  END ETL_RRP_TAB_DATA_TO_FDW;
/

