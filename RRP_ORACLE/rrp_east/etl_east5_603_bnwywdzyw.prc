CREATE OR REPLACE PROCEDURE RRP_EAST.ETL_EAST5_603_BNWYWDZYW(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_EAST5_603_BNWYWDZYW
  *  功能描述：表内外业务抵质押物
  *  创建日期：20220712
  *  开发人员：王锐
  *  来源表： M_GUA_REL_COLL  担保合同与押品对应关系表
              M_GUA_COLL_INFO  抵质押物详细信息
              M_GUA_CONT_INFO  担保合同表
              M_PUM_ORG_INFO_EAST  机构表
              CODE_MAP   码值配置表
              CONFIG_ORG_REL  机构级次关系表
              CONFIG_TABLE_LIST   分行报送报表配置表
  *  目标表： EAST5_603_BNWYWDZYW 表内外业务抵质押物
  *
  *  配置表：
  *  修改情况：序号  修改日期  修改人     修改原因
  *             1    20221118    LHQ      模型层放开过滤条件，在报表层进行数据过滤
  *             2    20221130    LHQ      根据严希婧口径，直取押品系统抵质押率
  *             3    20221209    LHQ      严希婧反馈 当填报机构为第一顺位时，已抵押价值填报为0
  **            4    20251212    LIP      根据业务要求，剔除未签合同的担保合同
  ***************************************************************************/
AS
  V_P_DATE           VARCHAR2(8);    --数据日期
  V_MONTH_END_DATEID VARCHAR2(8);    --本月月底日期
  V_PARTITION_NAME   VARCHAR2(100);  --分区名称
  V_FREQ_FLAG        VARCHAR2(10);   --跑批频度
  V_STEP             INTEGER := 0;   --任务号
  V_COUNT            INTEGER := 0;   --数据记录条数
  V_STARTTIME        DATE;           --处理开始时间
  V_ENDTIME          DATE;           --处理结束时间
  V_SQLCOUNT         INTEGER := 0;   --更新或删除影响的记录数
  V_SQLMSG           VARCHAR2(300);  --SQL执行描述信息
  V_STEP_DESC        VARCHAR2(100);  --处理步骤描述
  V_PROC_NAME        VARCHAR2(100) := 'ETL_EAST5_603_BNWYWDZYW'; --存储过程名称
  V_TABLE_NAME       VARCHAR2(100) := 'EAST5_603_BNWYWDZYW'; --表名称
BEGIN
  V_P_DATE  := TO_CHAR(I_P_DATE); 
  O_ERRCODE := '0';
  V_MONTH_END_DATEID := TO_CHAR(LAST_DAY(TO_DATE(V_P_DATE,'YYYYMMDD')),'YYYYMMDD');
  V_PARTITION_NAME   := 'PARTITION_' || V_P_DATE;
  V_FREQ_FLAG        := RRP_EAST.FUN_FREQ(I_P_DATE,V_PROC_NAME);

  --判断跑批频度
  IF V_FREQ_FLAG = '1' THEN --后面接正常的报表逻辑加工脚本,如果批次日期满足跑批频度要求，才会跑批，否则跳过
    --新建分区
    V_STEP := 1;
    V_STEP_DESC := '新建分区';
    V_STARTTIME := SYSDATE;
    RRP_EAST.ETL_PARTITION_ADD(I_P_DATE, V_TABLE_NAME, 1, O_ERRCODE);

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    --清空表分区数据
    V_STEP := V_STEP + 1;
    V_STEP_DESC := '清空表分区数据';
    V_STARTTIME := SYSDATE;
    RRP_EAST.ETL_PARTITION_TRUNCATE(I_P_DATE, V_TABLE_NAME, O_ERRCODE); --清空当日分区以便重跑

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    --程序加工开始
    V_STEP := V_STEP + 1;
    V_STEP_DESC := '程序跑批开始';
    V_STARTTIME := SYSDATE;
    INSERT INTO RRP_EAST.EAST5_603_BNWYWDZYW
      (RID, --数据主键
       JRXKZH, --金融许可证号
       NBJGH, --内部机构号
       DBHTH, --担保合同号
       YPBH, --押品编号
       YPLX, --押品类型
       YPMC, --押品名称
       DZYWZT, --抵质押物状态
       BZ, --币种
       PGJZ, --起始估值
       YXRDJZ, --最新估值
       YDYJZ, --已抵押价值
       DZYL, --抵质押率
       CZQSW, --处置权顺位
       YPSYRMC, --押品所有人名称
       YPSYRZJLB, --押品所有人证件类别
       YPSYRZJHM, --押品所有人证件号码
       ZYPZHM, --质押票证号码
       ZYPZQFJG, --质押票证签发机构
       QZDJHM, --权证登记号码
       QZDJMJ, --权证登记面积
       DBHTZT, --担保合同状态
       BBZ, --备注
       CJRQ, --采集日期
       DEPT_NO, --部门编号
       SRC_SYS_ID, --来源系统ID
       ISSUED_NO, --填报机构
       ORG_NO, --报送机构
       ADDRESS, --归属地
       YPSYRMC_ORIG, --押品所有人名称（脱敏前）
       YPSYRZJHM_ORIG, --押品所有人证件号码（脱敏前）
       YPSYRMC_OTH, --所有人是否个人
       GSFZJG --归属分支机构
       ,BDBRSFGR  --被担保人是否个人
       ,NBJGMC  --内部机构名称
       )
      WITH XDHTB_KHMC_OTH AS ( --MODIFY BY TANGAN AT 20230201
    SELECT /*+MATERIALIZE*/T1.GUA_CONT_ID,MAX(TRIM(T2.KHMC_OTH)) KHMC_OTH,
           SUM(CASE WHEN NVL(T1.BIZ_ACT_END_DT,'99991231') > V_P_DATE THEN 1
                    ELSE 0
                END) YX_ZS
      FROM RRP_MDL.M_GUA_REL_BSN_CONT T1 --担保合同和业务合同对应关系表
      LEFT JOIN RRP_EAST.EAST5_501_XDHTB T2
        ON T2.XDHTH = T1.BIZ_CONT_ID
       AND T2.CJRQ = V_P_DATE
      LEFT JOIN RRP_MDL.M_GUA_CONT_INFO T3 --担保合同表
        ON T3.GUA_CONT_ID = T1.GUA_CONT_ID
       AND NVL(T3.GUA_CONT_END_DT,'99991231') >= TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM'),'YYYYMMDD') --MOD BY LIP 20251229 因一表通的范围需要取当年内有效数据，EAST只卡当月内有效的数据
       AND CASE WHEN T3.GUA_CONT_EFF_DT NOT IN ('00010101','29991231','20991231') THEN T3.GUA_CONT_EFF_DT
                WHEN T3.GUA_CONT_SIGN_DT NOT IN ('00010101','29991231','20991231') THEN T3.GUA_CONT_SIGN_DT
                ELSE '99991231'
            END <= V_P_DATE --MOD BY LIP 20260323 根据业务需求，剔除合同起始日录入有问题大于采集日期的数据
       AND T3.DATA_DT = V_P_DATE
     WHERE (T2.XDHTH IS NOT NULL OR T3.LOAN_MON_FLAG = 'Y') --MOD BY LIP 2024716
       AND NVL(T3.GUA_CONT_STAT_YBT,'1') NOT IN ('110') --未签合同 --MOD BY LIP 20251212 根据业务要求，剔除未签合同的担保合同
       AND (NVL(T1.BIZ_ACT_END_DT,'99991231') >= TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM'),'YYYYMMDD') OR T2.XDHTH IS NOT NULL)
       AND NVL(T1.GUA_REL_END_DT,'99991231') >= TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM'),'YYYYMMDD') --MOD BY LIP 20251229 因一表通的范围需要取当年内有效数据，EAST只卡当月内有效的数据
       AND T1.DATA_DT = V_P_DATE
     GROUP BY T1.GUA_CONT_ID)
    SELECT SYS_GUID()                                              AS RID, --数据主键
           D.FIN_PERMIT_NO                                         AS JRXKZH, --金融许可证号
           D.ORG_ID                                                AS NBJGH, --内部机构号
           A.GUA_CONT_ID                                           AS DBHTH, --担保合同号
           A.COLL_ID                                               AS YPBH, --押品编号
           CASE WHEN B.COLL_TYP LIKE 'A01%' THEN '1.1现金及其等价物'
                WHEN B.COLL_TYP = 'A02' THEN '1.2贵金属'
                WHEN B.COLL_TYP = 'A0301' THEN '1.3.1国债'
                WHEN B.COLL_TYP = 'A0302' THEN '1.3.2地方政府债'
                WHEN B.COLL_TYP = 'A0303' THEN '1.3.3央票'
                WHEN B.COLL_TYP = 'A0304' THEN '1.3.4政府机构债券'
                WHEN B.COLL_TYP = 'A0305' THEN '1.3.5政策性金融债'
                WHEN B.COLL_TYP = 'A0306' THEN '1.3.6商业性金融债'
                WHEN B.COLL_TYP LIKE 'A0307%' THEN '1.3.7非金融企业债'
                WHEN B.COLL_TYP LIKE 'A04%' THEN '1.4票据'
                WHEN B.COLL_TYP LIKE 'A05%' THEN '1.5股票（权）/基金'
                WHEN B.COLL_TYP = 'A06' THEN '1.6保单'
                WHEN B.COLL_TYP = 'A07' THEN '1.7资产管理产品'
                WHEN B.COLL_TYP = 'A08' THEN '1.8其他金融质押品'
                WHEN B.COLL_TYP LIKE 'B%' THEN '2.应收账款类'
                WHEN B.COLL_TYP LIKE 'C01%' THEN '3.1居住用房地产'
                WHEN B.COLL_TYP = 'C02' THEN '3.2经营性房地产'
                WHEN B.COLL_TYP = 'C03' THEN '3.3居住用房地产建设用地使用权'
                WHEN B.COLL_TYP = 'C04' THEN '3.4经营性房地产建设用地使用权'
                WHEN B.COLL_TYP = 'C05' THEN '3.5房产类在建工程'
                WHEN B.COLL_TYP = 'C06' THEN '3.6其他房地产类押品'
                WHEN B.COLL_TYP IN ('D0101','D0102','D0103') THEN '4.1存货、仓单和提单'
                WHEN B.COLL_TYP = 'D02' THEN '4.2机器设备'
                WHEN B.COLL_TYP LIKE 'D03%' THEN '4.3交通运输设备'
                WHEN B.COLL_TYP LIKE 'D06%' THEN '4.4资源资产'
                WHEN B.COLL_TYP LIKE 'D0701%' THEN '4.5知识产权'
                ELSE '4.6其他-其他'
            END                                                AS YPLX, --押品类型
           B.COLL_NM                                           AS YPMC, --押品名称
           CODE.TAR_VALUE_NAME                                 AS DZYWZT, --抵质押物状态
           B.CUR                                               AS BZ, --币种
           B.INIT_VALT                                         AS PGJZ, --起始估值
           B.BANK_IDNT_PRC_VAL                                 AS YXRDJZ, --最新估值
           --B.ALDY_MTG_VAL                                      AS YDYJZ, --已抵押价值
           CASE WHEN A.COLL_SEQ = '第一顺位'  THEN 0
                ELSE NVL(B.PRIOR_COMP_WEIGHT_QTTY,B.ALDY_MTG_VAL)
            END                                                AS YDYJZ, --已抵押价值
           --MODIFY 20221209 LHQ 严希婧反馈 当填报机构为第一顺位时，已抵押价值填报为0,处置权顺位非第一顺位，取押品系统对应押品编号查询信息的优先受偿权金额
           --C.MTG_PLG_RTO                                       AS DZYL, --抵质押率
           NVL(C.ACTL_MTG_PLG_RTO,0)                           AS DZYL, --抵质押率  MODIFY 20221130 LHQ 根据严希婧口径，直取押品系统抵质押率
           A.COLL_SEQ                                          AS CZQSW, --处置权顺位
           CASE WHEN B.COLL_OWNER_CRDL_TYP LIKE '1%'
                THEN TRIM(RRP_EAST.FUN_DESENSITIZATION(REGEXP_REPLACE(B.COLL_OWNER_NM,'[[:punct:]]',''),0)) --MODIFY BY LIP
                --MOD BY LIP 20230505 当对公客户的名称都是中文名时，将其中的()改为（）
                WHEN REGEXP_REPLACE(TRIM(B.COLL_OWNER_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(B.COLL_OWNER_NM),'(','（'),')','）'),' ','')
                ELSE TRIM(B.COLL_OWNER_NM)
            END                                                AS YPSYRMC, --押品所有人名称
           --CODE1.TAR_VALUE_NAME                               AS YPSYRZJLB, --押品所有人证件类别
           --TRIM(SUBSTRB(CODE1.TAR_VALUE_NAME,1,40))            AS YPSYRZJLB, --押品所有人证件类别
           TRIM(SUBSTRB(CODE1.TAR_VALUE_NAME,1,60))            AS YPSYRZJLB, --押品所有人证件类别 --MODIFY BY LIP 20240409 改为UTF-8的长度
           CASE WHEN B.COLL_OWNER_CRDL_TYP LIKE '1%' THEN --涉及个人身份证件时需按照本规范给定规则进行脱敏处理
                 --MOD BY LIP 20240909 调整取身份证件号码UTF-8编码的前6个字节的取数口径
                 CASE WHEN LENGTHB(TRIM(SUBSTRB(B.COLL_OWNER_CRDL_NO,1,6))) = 6 THEN TRIM(SUBSTRB(B.COLL_OWNER_CRDL_NO,1,6))
                      WHEN LENGTHB(TRIM(SUBSTRB(B.COLL_OWNER_CRDL_NO,1,6))) = 5 THEN '0'||TRIM(SUBSTRB(B.COLL_OWNER_CRDL_NO,1,6))
                      WHEN LENGTHB(TRIM(SUBSTRB(B.COLL_OWNER_CRDL_NO,1,6))) = 4 THEN '00'||TRIM(SUBSTRB(B.COLL_OWNER_CRDL_NO,1,6))
                      WHEN LENGTHB(TRIM(SUBSTRB(B.COLL_OWNER_CRDL_NO,1,6))) = 3 THEN '000'||TRIM(SUBSTRB(B.COLL_OWNER_CRDL_NO,1,6))
                      WHEN LENGTHB(TRIM(SUBSTRB(B.COLL_OWNER_CRDL_NO,1,6))) = 2 THEN '0000'||TRIM(SUBSTRB(B.COLL_OWNER_CRDL_NO,1,6))
                      WHEN LENGTHB(TRIM(SUBSTRB(B.COLL_OWNER_CRDL_NO,1,6))) = 1 THEN '00000'||TRIM(SUBSTRB(B.COLL_OWNER_CRDL_NO,1,6))
                      WHEN LENGTHB(TRIM(SUBSTRB(B.COLL_OWNER_CRDL_NO,1,6))) = 0 THEN '000000'||TRIM(SUBSTRB(B.COLL_OWNER_CRDL_NO,1,6))
                  END||RRP_EAST.SM3_ENCRYPT(RRP_EAST.FUN_DESENSITIZATION(REGEXP_REPLACE(B.COLL_OWNER_NM,'[[:punct:]]',''),1)||
                  UPPER(B.COLL_OWNER_CRDL_NO))--MODIFY BY LIP
                ELSE B.COLL_OWNER_CRDL_NO
            END                                                AS YPSYRZJHM, --押品所有人证件号码
           CASE WHEN C.GUA_TYP LIKE 'A%' OR B.COLL_TYP LIKE 'C01%' OR B.COLL_TYP IN ('C02','C03','C04','C05','C06') THEN NULL
                ELSE B.PLG_TKT_NO
            END                                                AS ZYPZHM, --质押票证号码
           /*20230129 LHQ 根据业务口径，质押票证号码适用押品类型为票据、存单等；押品类型为“3.1居住用房地产”、“3.2经营性房地产”、“3.3居住用房地产建设用地使用权”、
           “3.4经营性房地产建设用地使用权”、“3.5房产类在建工程”、“3.6其他房地产类押品”等，担保方式为抵押，非质押，不适用于该字段，
           直接按空值报送*/
           CASE WHEN C.GUA_TYP LIKE 'A%' OR B.COLL_TYP LIKE 'C01%' OR B.COLL_TYP IN ('C02','C03','C04','C05','C06') THEN NULL
                ELSE B.PLG_TKT_ISU_ORG_ID
            END                                                AS ZYPZQFJG, --质押票证签发机构
           --B.WRNT_REGD_NO                                      AS QZDJHM, --权证登记号码
           --CASE WHEN B.COLL_TYP LIKE 'C%' THEN B.WRNT_REGD_NO
           --当权证登记号码为空时，取 BELONG_CERT_NO 权属证件号
           CASE WHEN B.COLL_TYP LIKE 'C%' THEN NVL(TRIM(B.WRNT_REGD_NO),TRIM(B.BELONG_CERT_NO))
                ELSE C.GUA_CONT_ID
            END                                                AS QZDJHM, --权证登记号码  -- modify by 20221128 LHQ
           /*据监管发文：当抵质押物类型为商业房地产和居住用房地产时，填写不动产登记部门给银行的抵押登记证明编号。
           对于抵质押物类型不为房地产或无抵押登记证明编号的业务，可以填写所有权证编号、合同编号或他项权证编号。*/
           B.WRNT_REGD_AREA                                    AS QZDJMJ, --权证登记面积
           CASE --WHEN SUBSTR(TO_CHAR(SX.MAX_DT,'YYYYMMDD'),1,6)||'01' = SUBSTR(V_P_DATE,1,6)||'01' THEN '失效'
                WHEN EE.YX_ZS = 0 THEN '失效' --MOD BY LIP 20240716
                --MODIFY 20230313 LHQ 当担保合同旗下所有业务合同和额度合同的状态均为4（即失效）是和最大更新日期等于当月，担保合同状态更新为失效
                WHEN C.GUA_CONT_STAT = 'Y' THEN '有效'
                WHEN C.GUA_CONT_STAT = 'N' THEN '失效'
            END                                                AS DBHTZT, --担保合同状态
           ''                                                  AS BBZ, --备注
           V_MONTH_END_DATEID                                  AS CJRQ, --采集日期
           '000'                                               AS DEPT_NO, --部门编号
           '01'                                                AS SRC_SYS_ID, --来源系统ID
           '000000'                                            AS ISSUED_NO, --填报机构
           ORG.ORG_ID_LEL_0                                    AS ORG_NO, --报送机构
           CASE WHEN LIST.FLAG = 1 THEN ORG.ORG_ID_LEL_1
                ELSE LIST.REP_ORG_ID
            END                                                AS ADDRESS, --归属地
           --B.COLL_OWNER_NM                                     AS YPSYRMC_ORIG, --押品所有人名称（脱敏前）
           --MOD BY LIP 20230505 当对公客户的名称都是中文名时，将其中的()改为（）
           CASE WHEN REGEXP_REPLACE(TRIM(B.COLL_OWNER_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(B.COLL_OWNER_NM),'(','（'),')','）'),' ','')
                ELSE TRIM(B.COLL_OWNER_NM)
            END                                                AS YPSYRMC_ORIG, --押品所有人名称（脱敏前）
           B.COLL_OWNER_CRDL_NO                                AS YPSYRZJHM_ORIG, --押品所有人证件号码（脱敏前）
           CASE WHEN B.COLL_OWNER_CRDL_TYP LIKE '1%' THEN '是'
                ELSE '否'
            END                                                AS YPSYRMC_OTH, --所有人是否个人
           CASE WHEN LIST.FLAG = 1 THEN D.GSFZJG
                ELSE '9999'
            END                                                AS GSFZJG,--归属分支机构
           NVL(TRIM(EE.KHMC_OTH),'否')                         AS BDBRSFGR,  --被担保人是否个人
           D.ORG_NM                                            AS NBJGMC  --内部机构名称
      FROM RRP_MDL.M_GUA_REL_COLL A --担保合同与押品对应关系表
     INNER /*LEFT*/ JOIN RRP_MDL.M_GUA_COLL_INFO B --抵质押物详细信息
        ON B.COLL_ID = A.COLL_ID
       --AND B.EAST_CD = '1' --MODIFY BY LIP 20220812 过滤EAST不需报送部分
       AND B.DATA_DT = V_P_DATE
     INNER /*LEFT*/ JOIN RRP_MDL.M_GUA_CONT_INFO C --担保合同表
        ON C.GUA_CONT_ID = A.GUA_CONT_ID
       AND NVL(C.GUA_CONT_STAT_YBT,'1') NOT IN ('110') --未签合同 --MOD BY LIP 20251212 根据业务要求，剔除未签合同的担保合同
       AND NVL(C.GUA_CONT_END_DT,'99991231') >= TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM'),'YYYYMMDD') --MOD BY LIP 20251229 因一表通的范围需要取当年内有效数据，EAST只卡当月内有效的数据
       AND C.DATA_DT = V_P_DATE
     INNER JOIN XDHTB_KHMC_OTH EE --MOD BY LIP 20230609 剔除未生效或撤销的合同
        ON EE.GUA_CONT_ID = A.GUA_CONT_ID
      LEFT JOIN RRP_MDL.ORG_CONFIG M --机构映射表
        ON M.ORG_ID = C.ORG_ID
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST D --机构表
        ON D.ORG_ID = NVL(M.ORG_ID1,'800')
       AND D.DATA_DT = V_P_DATE
      /*LEFT JOIN SX_CONT SX --担保合同旗下所有业务合同和额度合同的状态和最大更新日期
        ON SX.GUAR_CONT_ID = A.GUA_CONT_ID*/
      LEFT JOIN RRP_MDL.CODE_MAP CODE --码值配置表
        ON CODE.SRC_VALUE_CODE = B.COLL_STAT
       AND CODE.SRC_CLASS_CODE = 'D0123' --抵质押物状态
       AND CODE.TAR_CLASS_CODE = 'D0123' --抵质押物状态
       AND CODE.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE1 --码值配置表
        ON CODE1.SRC_VALUE_CODE = B.COLL_OWNER_CRDL_TYP
       AND CODE1.SRC_CLASS_CODE = 'C0001' --押品所有人证件类别
       AND CODE1.TAR_CLASS_CODE = 'C0001' --押品所有人证件类别
       AND CODE1.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE2 --码值配置表
        ON CODE2.SRC_VALUE_CODE = C.GUA_CONT_STAT
       AND CODE2.SRC_CLASS_CODE = 'Z0002' --担保合同状态
       AND CODE2.TAR_CLASS_CODE = 'Z0002' --担保合同状态
       AND CODE2.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CONFIG_ORG_REL ORG --机构级次关系表
        ON ORG.ORG_ID = D.ORG_ID
      LEFT JOIN RRP_MDL.CONFIG_TABLE_LIST LIST --分行报送报表配置表：记录分行报送的报表范围是全行数据还是本行数据 1 只报分行 0 全表报送
        ON 1 = 1
       AND UPPER(LIST.TABLE_NAME) = V_TABLE_NAME
     WHERE B.COLL_TYP != 'A0104' --剔除保证金
       --AND NOT EXISTS(SELECT * FROM SX_CONT A1 WHERE A.GUA_CONT_ID = A1.GUAR_CONT_ID) --ADD 20230306 LHQ 根据信贷口径，过滤不符合条件的担保合同
       --AND (B.COL_TYPE_ID LIKE 'DY%' OR B.COL_TYPE_ID LIKE 'ZY%') --MODIFY 20221118 LHQ 模型层放开过滤条件，在报表层进行数据过滤
       AND B.COL_TYPE_ID NOT LIKE '98%' --MOD BY LIP 20251015 押品系统重构改造
       AND B.INSTO_STATUS_CD NOT IN ('01','05','08','06','07') --剔除01未入库、05已出 --ADD BY LIP 20260212 CD1123剔除待入库的数据\遗失/灭失\无效数据
       AND A.DATA_DT = V_P_DATE;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    V_STEP := V_STEP + 1;
    V_STEP_DESC := '查询数据是否重复';
    V_STARTTIME := SYSDATE;
      WITH TMP1 AS (
    SELECT CJRQ,DBHTH,YPBH,COUNT(1)
      FROM RRP_EAST.EAST5_603_BNWYWDZYW T
     WHERE CJRQ = V_P_DATE
     GROUP BY CJRQ,DBHTH,YPBH
    HAVING COUNT(1) > 1)
    SELECT NVL(COUNT(1),0) INTO V_COUNT FROM TMP1;

    O_ERRCODE := '0';
    V_ENDTIME := SYSDATE;
    IF V_COUNT > 0 THEN
       O_ERRCODE := '1';
       V_SQLMSG  := 'EAST5_603_BNWYWDZYW(CJRQ,DBHTH,YPBH)数据重复';
       ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_COUNT,O_ERRCODE,V_SQLMSG);
       RETURN;
    END IF;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_COUNT,O_ERRCODE,'');

    --表分析
    V_STEP := V_STEP + 1;
    V_STEP_DESC := '表分析开始';
    V_STARTTIME := SYSDATE;
    RRP_EAST.ETL_DBMS_STATS(V_P_DATE,V_TABLE_NAME,V_PARTITION_NAME,O_ERRCODE);

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');
  END IF;

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '跑批结束';
  V_STARTTIME := SYSDATE;
  --在过程跑批完成记录表中插入记录，调度查询该表判断过程是是否跑批完成
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE,PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

EXCEPTION
  WHEN OTHERS THEN
    O_ERRCODE := '1';
    V_SQLMSG  := '跑批错误：['||SQLCODE||'],描述信息：'||SQLERRM;
    V_ENDTIME := SYSDATE;
    ROLLBACK;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_EAST5_603_BNWYWDZYW;
/

