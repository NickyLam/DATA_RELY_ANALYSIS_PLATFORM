CREATE OR REPLACE PROCEDURE RRP_EAST.ETL_EAST5_203_DGKHXXB(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
/***********************************************************************
  **  存储过程详细说明：对公客户信息表
  **  存储过程名称:  ETL_EAST5_203_DGKHXXB
  **  存储过程创建日期:2022-03-07
  **  存储过程创建人:蔡正伟
  **  输入参数:   I_P_DATE
  **  输出参数:   O_ERRCODE
  **  返回值:     O_ERRCODE
  **  修改日期    修改人      修改原因
  **  20220424    蔡正伟      修改主表与EAST5_KHXXB 关联条件，增加索引，提高效率
  **  20220507    付善斌      解决证件号码为空问题
  **  20220524    付善斌      填报机构源调整
  **  20220601    付善斌      归属机构逻辑添加
  **  20220603    付善斌      财务负责人为数字时留空
  **  20220628    LIP         修改日志记录格式，修改字段超长、字段换行问题
  **  20230427    LIP         将客户名称全是中文的()改为（）
  ************************************************************************/
IS
  V_P_DATE           VARCHAR2(8);      --数据日期
  V_MONTH_END_DATEID VARCHAR2(8);      --本月月底日期
  V_PARTITION_NAME   VARCHAR2(100);    --分区名称
  V_FREQ_FLAG        VARCHAR2(10);     --跑批频度
  V_STEP             INTEGER := 0;     --任务号
  V_COUNT            INTEGER := 0;     --数据记录条数
  V_STARTTIME        DATE := SYSDATE;  --处理开始时间
  V_ENDTIME          DATE := SYSDATE;  --处理结束时间
  V_SQLCOUNT         INTEGER := 0;     --更新或删除影响的记录数
  V_SQLMSG           VARCHAR2(300);    --SQL执行描述信息
  V_STEP_DESC        VARCHAR2(100);    --处理步骤描述
  V_PROC_NAME        VARCHAR2(100) := UPPER('ETL_EAST5_203_DGKHXXB'); --存储过程名称
  V_TABLE_NAME       VARCHAR2(100) := UPPER('EAST5_203_DGKHXXB'); --表名称
BEGIN
  V_P_DATE  := TO_CHAR(I_P_DATE);
  O_ERRCODE := '0';
  V_MONTH_END_DATEID := TO_CHAR(LAST_DAY(TO_DATE(V_P_DATE,'YYYYMMDD')),'YYYYMMDD');
  V_PARTITION_NAME   := 'PARTITION_' || V_P_DATE;
  V_FREQ_FLAG        := RRP_EAST.FUN_FREQ(I_P_DATE,V_PROC_NAME);

  --判断跑批频度
  IF V_FREQ_FLAG = '1' THEN
    /*增加分区*/
    V_STEP := V_STEP + 1;
    V_STEP_DESC := '删除当日分区数据';
    V_STARTTIME := SYSDATE;
    --删除当日分区数据
    RRP_EAST.ETL_PARTITION_ADD(V_P_DATE, V_TABLE_NAME, 1, O_ERRCODE);
    RRP_EAST.ETL_PARTITION_TRUNCATE(V_P_DATE, V_TABLE_NAME, O_ERRCODE);

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    --程序业务逻辑处理主体部分
    V_STEP := V_STEP + 1;
    V_STEP_DESC := '对公客户信息表-加工法定代表人信息';
    V_STARTTIME := SYSDATE;
    EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_EAST.EAST5_203_DGKHXXB_TMP';
    INSERT INTO RRP_EAST.EAST5_203_DGKHXXB_TMP
      (DATA_DT,
       LGL_REP_ID,
       CUST_ID,
       REL_TYP,
       REL_PSN_TYP,
       REL_PSN_CUST_NM,
       REL_PSN_CUST_ID,
       REL_PSN_CTRY_CD,
       REL_PSN_CRDL_TYP,
       REL_PSN_CRDL_NO,
       PBC_NO,
       FIN_PERMIT_NO,
       ACT_CNTLR_FLG,
       ACT_CNTLR_TYP,
       REGD_CD_RSK,
       UPD_INFO_DT,
       SENIOR_IMPT_PSN_FLG,
       REL_STAT,
       PP1_NO,
       PP1_ISU_DT,
       PP1_EXP_DT,
       PP2_NO,
       PP2_ISU_DT,
       PP2_EXP_DT,
       PP3_NO,
       PP3_ISU_DT,
       PP3_EXP_DT,
       OTH_CRDL_TYP1,
       OTH_CRDL_NO1,
       OTH_CRDL_TYP2,
       OTH_CRDL_NO2,
       DEPT_LINE,
       DATA_SRC,
       NUM,
       FRDBZJHM)
    SELECT DATA_DT,
           LGL_REP_ID,
           CUST_ID,
           REL_TYP,
           REL_PSN_TYP,
           --REL_PSN_CUST_NM,
           TRIM(REGEXP_REPLACE(REL_PSN_CUST_NM,'[/$\]','')) AS REL_PSN_CUST_NM, --关联人客户名称 --MOD BY LIP 20260417
           REL_PSN_CUST_ID,
           REL_PSN_CTRY_CD,
           REL_PSN_CRDL_TYP,
           --REL_PSN_CRDL_NO,
           TRIM(REGEXP_REPLACE(REL_PSN_CRDL_NO,'[/$\]','')) AS REL_PSN_CRDL_NO, --关联人证件号码 --MOD BY LIP 20260417
           PBC_NO,
           FIN_PERMIT_NO,
           ACT_CNTLR_FLG,
           ACT_CNTLR_TYP,
           REGD_CD_RSK,
           UPD_INFO_DT,
           SENIOR_IMPT_PSN_FLG,
           REL_STAT,
           PP1_NO,
           PP1_ISU_DT,
           PP1_EXP_DT,
           PP2_NO,
           PP2_ISU_DT,
           PP2_EXP_DT,
           PP3_NO,
           PP3_ISU_DT,
           PP3_EXP_DT,
           OTH_CRDL_TYP1,
           OTH_CRDL_NO1,
           OTH_CRDL_TYP2,
           OTH_CRDL_NO2,
           DEPT_LINE,
           DATA_SRC,
           --ROW_NUMBER() OVER(PARTITION BY T.CUST_ID,T.REL_TYP,T.REL_PSN_TYP ORDER BY T.REL_PSN_CRDL_NO DESC) AS NUM,
           ROW_NUMBER() OVER(PARTITION BY T.CUST_ID,T.REL_TYP,T.REL_PSN_TYP ORDER BY T.DATA_SRC,
             T.REL_PSN_CRDL_TYP NULLS LAST,T.REL_PSN_CRDL_NO DESC NULLS LAST) AS NUM,
           --MOD BY LIP 20240909 调整取身份证件号码UTF-8编码的前6个字节的取数口径
           /*CASE WHEN LENGTHB(TRIM(SUBSTRB(T.REL_PSN_CRDL_NO,1,6))) = 6 THEN TRIM(SUBSTRB(T.REL_PSN_CRDL_NO,1,6))
                WHEN LENGTHB(TRIM(SUBSTRB(T.REL_PSN_CRDL_NO,1,6))) = 5 THEN '0'||TRIM(SUBSTRB(T.REL_PSN_CRDL_NO,1,6))
                WHEN LENGTHB(TRIM(SUBSTRB(T.REL_PSN_CRDL_NO,1,6))) = 4 THEN '00'||TRIM(SUBSTRB(T.REL_PSN_CRDL_NO,1,6))
                WHEN LENGTHB(TRIM(SUBSTRB(T.REL_PSN_CRDL_NO,1,6))) = 3 THEN '000'||TRIM(SUBSTRB(T.REL_PSN_CRDL_NO,1,6))
                WHEN LENGTHB(TRIM(SUBSTRB(T.REL_PSN_CRDL_NO,1,6))) = 2 THEN '0000'||TRIM(SUBSTRB(T.REL_PSN_CRDL_NO,1,6))
                WHEN LENGTHB(TRIM(SUBSTRB(T.REL_PSN_CRDL_NO,1,6))) = 1 THEN '00000'||TRIM(SUBSTRB(T.REL_PSN_CRDL_NO,1,6))
                WHEN NVL(LENGTHB(TRIM(SUBSTRB(T.REL_PSN_CRDL_NO,1,6))),0) = 0 THEN '000000'||TRIM(SUBSTRB(T.REL_PSN_CRDL_NO,1,6))
            END||RRP_EAST.SM3_ENCRYPT(RRP_EAST.FUN_DESENSITIZATION(REGEXP_REPLACE(T.REL_PSN_CUST_NM,'[[:punct:]]',''),1) ||
                                     UPPER(T.REL_PSN_CRDL_NO)) AS FRDBZJHM  --法人代表证件号码 --MODIFY BY LIP 20220628*/
           CASE WHEN LENGTHB(TRIM(SUBSTRB(REGEXP_REPLACE(T.REL_PSN_CRDL_NO,'[/$\]',''),1,6))) = 6
                THEN TRIM(SUBSTRB(REGEXP_REPLACE(T.REL_PSN_CRDL_NO,'[/$\]',''),1,6))
                WHEN LENGTHB(TRIM(SUBSTRB(REGEXP_REPLACE(T.REL_PSN_CRDL_NO,'[/$\]',''),1,6))) = 5
                THEN '0'||TRIM(SUBSTRB(REGEXP_REPLACE(T.REL_PSN_CRDL_NO,'[/$\]',''),1,6))
                WHEN LENGTHB(TRIM(SUBSTRB(REGEXP_REPLACE(T.REL_PSN_CRDL_NO,'[/$\]',''),1,6))) = 4
                THEN '00'||TRIM(SUBSTRB(REGEXP_REPLACE(T.REL_PSN_CRDL_NO,'[/$\]',''),1,6))
                WHEN LENGTHB(TRIM(SUBSTRB(REGEXP_REPLACE(T.REL_PSN_CRDL_NO,'[/$\]',''),1,6))) = 3
                THEN '000'||TRIM(SUBSTRB(REGEXP_REPLACE(T.REL_PSN_CRDL_NO,'[/$\]',''),1,6))
                WHEN LENGTHB(TRIM(SUBSTRB(REGEXP_REPLACE(T.REL_PSN_CRDL_NO,'[/$\]',''),1,6))) = 2
                THEN '0000'||TRIM(SUBSTRB(REGEXP_REPLACE(T.REL_PSN_CRDL_NO,'[/$\]',''),1,6))
                WHEN LENGTHB(TRIM(SUBSTRB(REGEXP_REPLACE(T.REL_PSN_CRDL_NO,'[/$\]',''),1,6))) = 1
                THEN '00000'||TRIM(SUBSTRB(REGEXP_REPLACE(T.REL_PSN_CRDL_NO,'[/$\]',''),1,6))
                WHEN NVL(LENGTHB(TRIM(SUBSTRB(REGEXP_REPLACE(T.REL_PSN_CRDL_NO,'[/$\]',''),1,6))),0) = 0
                THEN '000000'||TRIM(SUBSTRB(REGEXP_REPLACE(T.REL_PSN_CRDL_NO,'[/$\]',''),1,6))
            END||RRP_EAST.SM3_ENCRYPT(RRP_EAST.FUN_DESENSITIZATION(REGEXP_REPLACE(T.REL_PSN_CUST_NM,'[[:punct:]]',''),1)
                                      ||UPPER(T.REL_PSN_CRDL_NO)) AS FRDBZJHM  --法人代表证件号码 --MODIFY BY LIP 20260417
      FROM RRP_MDL.M_CUST_CORP_REL_SUB T
     WHERE T.REL_PSN_TYP = '01' --法定代表人
       AND T.DATA_DT = V_P_DATE;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    V_STEP := V_STEP + 1;
    V_STEP_DESC := '对公客户信息表--财务主管临时表处理';
    V_STARTTIME := SYSDATE;
    EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_EAST.EAST5_203_DGKHXXB_TMP1';
    INSERT INTO RRP_EAST.EAST5_203_DGKHXXB_TMP1
      (DATA_DT,
       LGL_REP_ID,
       CUST_ID,
       REL_TYP,
       REL_PSN_TYP,
       REL_PSN_CUST_NM,
       REL_PSN_CUST_ID,
       REL_PSN_CTRY_CD,
       REL_PSN_CRDL_TYP,
       REL_PSN_CRDL_NO,
       PBC_NO,
       FIN_PERMIT_NO,
       ACT_CNTLR_FLG,
       ACT_CNTLR_TYP,
       REGD_CD_RSK,
       UPD_INFO_DT,
       SENIOR_IMPT_PSN_FLG,
       REL_STAT,
       PP1_NO,
       PP1_ISU_DT,
       PP1_EXP_DT,
       PP2_NO,
       PP2_ISU_DT,
       PP2_EXP_DT,
       PP3_NO,
       PP3_ISU_DT,
       PP3_EXP_DT,
       OTH_CRDL_TYP1,
       OTH_CRDL_NO1,
       OTH_CRDL_TYP2,
       OTH_CRDL_NO2,
       DEPT_LINE,
       DATA_SRC,
       NUM,
       CWFZRZJHM)
    SELECT DATA_DT,
           LGL_REP_ID,
           CUST_ID,
           REL_TYP,
           REL_PSN_TYP,
           --REL_PSN_CUST_NM,
           TRIM(REGEXP_REPLACE(REL_PSN_CUST_NM,'[/$\]','')) AS REL_PSN_CUST_NM, --关联人客户名称 --MOD BY LIP 20260417
           REL_PSN_CUST_ID,
           REL_PSN_CTRY_CD,
           REL_PSN_CRDL_TYP,
           --REL_PSN_CRDL_NO,
           TRIM(REGEXP_REPLACE(REL_PSN_CRDL_NO,'[/$\]','')) AS REL_PSN_CRDL_NO, --关联人证件号码 --MOD BY LIP 20260417
           PBC_NO,
           FIN_PERMIT_NO,
           ACT_CNTLR_FLG,
           ACT_CNTLR_TYP,
           REGD_CD_RSK,
           UPD_INFO_DT,
           SENIOR_IMPT_PSN_FLG,
           REL_STAT,
           PP1_NO,
           PP1_ISU_DT,
           PP1_EXP_DT,
           PP2_NO,
           PP2_ISU_DT,
           PP2_EXP_DT,
           PP3_NO,
           PP3_ISU_DT,
           PP3_EXP_DT,
           OTH_CRDL_TYP1,
           OTH_CRDL_NO1,
           OTH_CRDL_TYP2,
           OTH_CRDL_NO2,
           DEPT_LINE,
           DATA_SRC,
           --ROW_NUMBER() OVER(PARTITION BY T.CUST_ID,T.REL_TYP,T.REL_PSN_TYP ORDER BY T.REL_PSN_CRDL_NO DESC) AS NUM,
           ROW_NUMBER() OVER(PARTITION BY T.CUST_ID,T.REL_TYP,T.REL_PSN_TYP ORDER BY T.DATA_SRC,
             T.REL_PSN_CRDL_TYP NULLS LAST,T.REL_PSN_CRDL_NO DESC NULLS LAST) AS NUM,
           --MOD BY LIP 20240909 调整取身份证件号码UTF-8编码的前6个字节的取数口径
           /*CASE WHEN LENGTHB(TRIM(SUBSTRB(T.REL_PSN_CRDL_NO,1,6))) = 6 THEN TRIM(SUBSTRB(T.REL_PSN_CRDL_NO,1,6))
                WHEN LENGTHB(TRIM(SUBSTRB(T.REL_PSN_CRDL_NO,1,6))) = 5 THEN '0'||TRIM(SUBSTRB(T.REL_PSN_CRDL_NO,1,6))
                WHEN LENGTHB(TRIM(SUBSTRB(T.REL_PSN_CRDL_NO,1,6))) = 4 THEN '00'||TRIM(SUBSTRB(T.REL_PSN_CRDL_NO,1,6))
                WHEN LENGTHB(TRIM(SUBSTRB(T.REL_PSN_CRDL_NO,1,6))) = 3 THEN '000'||TRIM(SUBSTRB(T.REL_PSN_CRDL_NO,1,6))
                WHEN LENGTHB(TRIM(SUBSTRB(T.REL_PSN_CRDL_NO,1,6))) = 2 THEN '0000'||TRIM(SUBSTRB(T.REL_PSN_CRDL_NO,1,6))
                WHEN LENGTHB(TRIM(SUBSTRB(T.REL_PSN_CRDL_NO,1,6))) = 1 THEN '00000'||TRIM(SUBSTRB(T.REL_PSN_CRDL_NO,1,6))
                WHEN NVL(LENGTHB(TRIM(SUBSTRB(T.REL_PSN_CRDL_NO,1,6))),0) = 0 THEN '000000'||TRIM(SUBSTRB(T.REL_PSN_CRDL_NO,1,6))
            END||RRP_EAST.SM3_ENCRYPT(RRP_EAST.FUN_DESENSITIZATION(REGEXP_REPLACE(T.REL_PSN_CUST_NM,'[[:punct:]]',''),1)||
                          UPPER(T.REL_PSN_CRDL_NO)) AS CWFZRZJHM --财务负责人证件号码 --MODIFY BY LIP 20220628*/
           CASE WHEN LENGTHB(TRIM(SUBSTRB(REGEXP_REPLACE(T.REL_PSN_CRDL_NO,'[/$\]',''),1,6))) = 6
                THEN TRIM(SUBSTRB(REGEXP_REPLACE(T.REL_PSN_CRDL_NO,'[/$\]',''),1,6))
                WHEN LENGTHB(TRIM(SUBSTRB(REGEXP_REPLACE(T.REL_PSN_CRDL_NO,'[/$\]',''),1,6))) = 5
                THEN '0'||TRIM(SUBSTRB(REGEXP_REPLACE(T.REL_PSN_CRDL_NO,'[/$\]',''),1,6))
                WHEN LENGTHB(TRIM(SUBSTRB(REGEXP_REPLACE(T.REL_PSN_CRDL_NO,'[/$\]',''),1,6))) = 4
                THEN '00'||TRIM(SUBSTRB(REGEXP_REPLACE(T.REL_PSN_CRDL_NO,'[/$\]',''),1,6))
                WHEN LENGTHB(TRIM(SUBSTRB(REGEXP_REPLACE(T.REL_PSN_CRDL_NO,'[/$\]',''),1,6))) = 3
                THEN '000'||TRIM(SUBSTRB(REGEXP_REPLACE(T.REL_PSN_CRDL_NO,'[/$\]',''),1,6))
                WHEN LENGTHB(TRIM(SUBSTRB(REGEXP_REPLACE(T.REL_PSN_CRDL_NO,'[/$\]',''),1,6))) = 2
                THEN '0000'||TRIM(SUBSTRB(REGEXP_REPLACE(T.REL_PSN_CRDL_NO,'[/$\]',''),1,6))
                WHEN LENGTHB(TRIM(SUBSTRB(REGEXP_REPLACE(T.REL_PSN_CRDL_NO,'[/$\]',''),1,6))) = 1
                THEN '00000'||TRIM(SUBSTRB(REGEXP_REPLACE(T.REL_PSN_CRDL_NO,'[/$\]',''),1,6))
                WHEN NVL(LENGTHB(TRIM(SUBSTRB(REGEXP_REPLACE(T.REL_PSN_CRDL_NO,'[/$\]',''),1,6))),0) = 0
                THEN '000000'||TRIM(SUBSTRB(REGEXP_REPLACE(T.REL_PSN_CRDL_NO,'[/$\]',''),1,6))
            END||RRP_EAST.SM3_ENCRYPT(RRP_EAST.FUN_DESENSITIZATION(REGEXP_REPLACE(T.REL_PSN_CUST_NM,'[[:punct:]]',''),1)
                                      ||UPPER(T.REL_PSN_CRDL_NO)) AS CWFZRZJHM --财务负责人证件号码 --MODIFY BY LIP 20260417
      FROM RRP_MDL.M_CUST_CORP_REL_SUB T
     WHERE T.REL_PSN_TYP = '05' --财务主管
       AND T.DATA_DT = V_P_DATE;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    V_STEP := V_STEP + 1;
    V_STEP_DESC := '对公客户信息表--插入目标表';
    V_STARTTIME := SYSDATE;
    INSERT INTO RRP_EAST.EAST5_203_DGKHXXB
      (RID, --数据主键
       JRXKZH, --金融许可证号
       NBJGH, --内部机构号
       YHJGMC, --银行机构名称
       KHTYBH, --客户统一编号
       KHMC, --客户名称
       KHLX, --客户类型
       ZJLB, --证件类别
       ZJHM, --证件号码
       FRDB, --法人代表
       FRDBZJLB, --法人代表证件类别
       FRDBZJHM, --法人代表证件号码
       CWFZR, --财务负责人
       CWFZRZJLB, --财务负责人证件类别
       CWFZRZJHM, --财务负责人证件号码
       JBCKZH, --基本存款账号
       JBCKZHKHHH, --基本存款账户开户行号
       JBCKZHKHHMC, --基本存款账户开户行名称
       ZCZB, --注册资本
       ZCZBBZ, --注册资本币种
       SSZB, --实收资本
       SSZBBZ, --实收资本币种
       ZCDZ, --注册地址
       LXDH, --联系电话
       JYFW, --经营范围
       CLRQ, --成立日期
       SSHY, --所属行业
       QYFL, --企业分类
       XDKHBZ, --信贷客户标志
       SCJLXDGXNY, --首次建立信贷关系年月
       SSGSBZ, --上市公司标志
       XYPJ, --信用评级
       YGRS, --员工人数
       XZQHDM, --行政区划代码
       FXYJXH, --风险预警信号
       GZSJDM, --关注事件代码
       BBZ, --备注
       CJRQ, --采集日期
       DEPT_NO, --部门编号
       SRC_SYS_ID, --来源系统ID
       ISSUED_NO, --填报机构
       ORG_NO, --报送机构
       ADDRESS, --归属地
       CWFZRZJHM_ORIG, --财务负责人证件号码（脱敏前）
       FRDBZJHM_ORIG, --法人代表证件号码（脱敏前）
       ZJHM_ORIG,--证件号码（脱敏前）
       GSFZJG --归属分支机构
       )
    SELECT SYS_GUID()                                                  AS RID,                 --数据主键
           B.FIN_PERMIT_NO                                             AS JRXKZH,              --金融许可证号
           B.ORG_ID                                                    AS NBJGH,               --内部机构号
           B.ORG_NM                                                    AS YHJGMC,              --银行机构名称
           A.CUST_ID                                                   AS KHTYBH,              --客户统一编号
           --A.CUST_NM                                                   AS KHMC,                --客户名称
           --MOD BY LIP 20230427 当对公客户的名称都是中文名时，将其中的()改为（）
           CASE WHEN REGEXP_REPLACE(A.CUST_NM,'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                 THEN REPLACE(REPLACE(REPLACE(TRIM(A.CUST_NM),'(','（'),')','）'),' ','')
                 ELSE TRIM(A.CUST_NM)
             END                                                       AS KHMC,                --客户名称
           CASE WHEN A.NATL_ECON_DEPT_CL LIKE 'B%' THEN '同业客户'
                WHEN A.NATL_ECON_DEPT_CL IN ('A01','A02') THEN '政府机关'
                WHEN A.CUST_CL = 'C' THEN '事业单位'
                WHEN A.CUST_CL = 'D' THEN '社会团体'
                WHEN A.CUST_CL = 'E' THEN '其他-个体工商户'
                WHEN A.NATL_ECON_DEPT_CL LIKE 'E%' AND A.REGD_CPTL_CUR <> 'CNY' THEN '境外机构'
                WHEN C.CUST_ID IS NOT NULL THEN '集团客户'
                ELSE '单一法人客户'
            END                                                        AS KHLX,                --客户类型
           CASE WHEN TRIM(A.PBC_NO) IS NOT NULL AND TRIM(A.NATL_ECON_DEPT_CL) NOT LIKE 'E%' THEN '银行机构代码'
                WHEN TRIM(A.PBC_NO) IS NOT NULL AND TRIM(A.NATL_ECON_DEPT_CL) LIKE 'E%' THEN 'SWIFT编码'
                WHEN TRIM(A.PBC_NO) IS NULL AND TRIM(A.FIN_PERMIT_NO) IS NOT NULL THEN '金融许可证号'
                --ELSE REPLACE(REPLACE(CODE.TAR_VALUE_NAME,CHR(10),''),CHR(13),'')
                --MODIFY BY LIP 20220628 字段超长问题
                --ELSE TRIM(SUBSTRB(TRIM(CODE.TAR_VALUE_NAME),1,40))
                ELSE TRIM(SUBSTRB(TRIM(CODE.TAR_VALUE_NAME),1,60)) --MODIFY BY LIP 20240409 改为UTF-8的长度
            END                                                        AS ZJLB,                --证件类别
           CASE WHEN TRIM(A.PBC_NO) IS NOT NULL
                THEN REPLACE(REPLACE(A.PBC_NO,CHR(10),''),CHR(13),'')
                WHEN TRIM(A.PBC_NO) IS NULL AND TRIM(A.FIN_PERMIT_NO) IS NOT NULL
                THEN REPLACE(REPLACE(A.FIN_PERMIT_NO,CHR(10),''),CHR(13),'')
                ELSE NVL(REPLACE(REPLACE(A.CRDL_NO,CHR(10),''),CHR(13),''),CC.MBR_USCC) --modify by tangan at 20221118
            END                                                        AS ZJHM,                --证件号码
           REPLACE(REPLACE(D.REL_PSN_CUST_NM,CHR(10),''),CHR(13),'')   AS FRDB,                --法人代表
           --MODIFY BY LIP 20220628 字段超长问题
           --TRIM(SUBSTRB(TRIM(CODE1.TAR_VALUE_NAME),1,40))              AS FRDBZJLB,            --法人代表证件类别
           TRIM(SUBSTRB(TRIM(CODE1.TAR_VALUE_NAME),1,60))              AS FRDBZJLB,            --法人代表证件类别 --MODIFY BY LIP 20240409 改为UTF-8的长度
           CASE WHEN TRIM(SUBSTRB(TRIM(CODE1.TAR_VALUE_NAME),1,40)) = '无证件' THEN NULL
                ELSE REPLACE(REPLACE(D.FRDBZJHM,CHR(10),''),CHR(13),'')
            END                                                        AS FRDBZJHM,            --法人代表证件号码  MODIFY BY TANGAN AT 20221130 将证件类型为无证件的证件号码置空
           --E.REL_PSN_CUST_NM                                           AS CWFZR,               --财务负责人
           CASE WHEN REGEXP_LIKE(TRIM(E.REL_PSN_CUST_NM),'^([\-]?[0-9])+$') THEN NULL
                ELSE REPLACE(REPLACE(E.REL_PSN_CUST_NM,CHR(10),''),CHR(13),'')
            END                                                        AS CWFZR,               --财务负责人
           --CODE2.TAR_VALUE_NAME                                       AS CWFZRZJLB,            --财务负责人证件类别
           CASE WHEN REGEXP_LIKE(TRIM(E.REL_PSN_CUST_NM),'^([\-]?[0-9])+$') THEN NULL
                --ELSE REPLACE(REPLACE(CODE2.TAR_VALUE_NAME,CHR(10),''),CHR(13),'')
                --MODIFY BY LIP 20220628 字段超长问题
                --ELSE TRIM(SUBSTRB(TRIM(CODE2.TAR_VALUE_NAME),1,40))
                ELSE TRIM(SUBSTRB(TRIM(CODE2.TAR_VALUE_NAME),1,60))--MODIFY BY LIP 20240409 改为UTF-8的长度
            END                                                        AS CWFZRZJLB,           --财务负责人证件类别
           CASE WHEN (CASE WHEN REGEXP_LIKE(TRIM(E.REL_PSN_CUST_NM),'^([\-]?[0-9])+$') THEN NULL
                           --ELSE TRIM(SUBSTRB(TRIM(CODE2.TAR_VALUE_NAME),1,40))
                           ELSE TRIM(SUBSTRB(TRIM(CODE2.TAR_VALUE_NAME),1,60))--MODIFY BY LIP 20240409 改为UTF-8的长度
                      END) = '无证件'
                  THEN NULL
                ELSE (CASE WHEN REGEXP_LIKE(TRIM(E.REL_PSN_CUST_NM),'^([\-]?[0-9])+$') THEN NULL
                           ELSE E.CWFZRZJHM
                      END)
           END                                                         AS CWFZRZJHM,           --财务负责人证件号码 MODIFY BY TANGAN AT 20221130 将证件类型为无证件的证件号码置空
           TRIM(A.BSC_DEP_ACC)                                         AS JBCKZH,              --基本存款账号
           CASE WHEN TRIM(A.BSC_DEP_ACC) IS NULL THEN NULL
                --ELSE A.BSC_ACC_OPEN_BANK_ID
                --ELSE MM.FIN_INST_CODE                               --MODIFY BY TANGAN AT 20221210
                ELSE NVL(MM.FIN_INST_CODE,A.BSC_ACC_OPEN_BANK_ID)     --MODIFY BY LHQ  AT 20230115
            END                                                        AS JBCKZHKHHH,          --基本存款账户开户行号
           CASE WHEN TRIM(A.BSC_DEP_ACC) IS NULL THEN NULL
                ELSE NVL(A.BSC_ACC_OPEN_BANK_NM,MM.ORG_NAME)          --modify by LHQ at 20230115
            END                                                        AS JBCKZHKHHMC,         --基本存款账户开户行名称
           A.REGD_CPTL                                                 AS ZCZB,                --注册资本
           CASE WHEN A.REGD_CPTL_CUR = '-' THEN NULL
                ELSE A.REGD_CPTL_CUR
            END                                                        AS ZCZBBZ,              --注册资本币种
           A.PAID_IN_CPTL                                              AS SSZB,                --实收资本
           A.PAID_IN_CPTL_CUR                                          AS SSZBBZ,              --实收资本币种
           --REPLACE(REPLACE(TRIM(A.REGD_ADDR),CHR(10),''),CHR(13),'')   AS ZCDZ,                --注册地址
           --SUBSTRB(TRIM(REPLACE(REPLACE(A.REGD_ADDR,CHR(10),''),CHR(13),'')),1,400) AS ZCDZ,   --注册地址
           SUBSTRB(TRIM(REPLACE(REPLACE(A.REGD_ADDR,CHR(10),''),CHR(13),'')),1,600) AS ZCDZ,   --注册地址--MODIFY BY LIP 20240409 改为UTF-8的长度
           A.TEL                                                       AS LXDH,                --联系电话
           --REPLACE(REPLACE(TRIM(A.OPR_SCOPE),CHR(10),''),CHR(13),'')   AS JYFW,                --经营范围
           --SUBSTRB(TRIM(REPLACE(REPLACE(A.OPR_SCOPE,CHR(10),''),CHR(13),'')),1,2000) AS JYFW,  --经营范围 --MODIFY BY LIP 20240409 改为UTF-8的长度
           SUBSTRB(TRIM(REPLACE(REPLACE(A.OPR_SCOPE,CHR(10),''),CHR(13),'')),1,3000) AS JYFW,  --经营范围
           NVL(A.ESTM_DT,'99991231')                                   AS CLRQ,                --成立日期
           TRIM(A.CUST_BLNG_IDY)                             AS SSHY,                          --所属行业 --MODIFY BY LIP 20240327
           CASE WHEN A.NATL_ECON_DEPT_CL LIKE 'E%' THEN '境外机构'
                WHEN A.NATL_ECON_DEPT_CL IN ('A01','A02') THEN '政府机关'
                WHEN A.CUST_CL = 'C' THEN '事业单位'
                WHEN A.CUST_CL = 'D' THEN '社会团体'
                WHEN A.CUST_CL LIKE 'A%' AND A.ENT_SCALE = 'L' THEN '大型企业'
                WHEN A.CUST_CL LIKE 'A%' AND A.ENT_SCALE = 'M' THEN '中型企业'
                WHEN A.CUST_CL LIKE 'A%' AND A.ENT_SCALE = 'S' THEN '小型企业'
                WHEN A.CUST_CL LIKE 'A%' AND A.ENT_SCALE = 'X' THEN '微型企业'
                ELSE '其他组织机构'
            END                                                        AS QYFL,                --企业分类
           CASE WHEN A.FIRST_ESTBL_CRDT_REL_DT IN ('00010101','20991231') THEN '否'
                WHEN A.FIRST_ESTBL_CRDT_REL_DT IS NOT NULL THEN '是'
                ELSE '否'
            END                                                        AS XDKHBZ,              --信贷客户标志
           CASE WHEN TRIM(A.FIRST_ESTBL_CRDT_REL_DT) IN ('00010101','20991231') THEN '999912'
                ELSE SUBSTR(NVL(TRIM(A.FIRST_ESTBL_CRDT_REL_DT),'99991231'),1,6)
            END                                                       AS SCJLXDGXNY,           --首次建立信贷关系年月
           NVL(CODE3.TAR_VALUE_NAME,'否')                             AS SSGSBZ,                --上市公司标志
           A.CUST_CRDT_RTG                                             AS XYPJ,                --信用评级
           A.EMP_NUM                                                  AS YGRS,                 --员工人数
           CASE WHEN A.OPR_LAND_AREA_CD <> '000000' THEN A.OPR_LAND_AREA_CD
                ELSE A.REGD_LAND_AREA_CD
            END                                                       AS XZQHDM,               --行政区划代码
           --MODIFY 20220114 LHQ 优先取客户经营地区行政代码不为‘000000’的值，再从注册地区行政代码取值。
           --REPLACE(REPLACE(TRIM(A.RSK_WARN_SGNL),CHR(10),''),CHR(13),'') AS FXYJXH,          --风险预警信号
           --REPLACE(REPLACE(TRIM(A.FOC_EVT),CHR(10),''),CHR(13),'')     AS GZSJDM,              --关注事件代码
           /*SUBSTRB(TRIM(REPLACE(REPLACE(A.RSK_WARN_SGNL,CHR(10),''),CHR(13),'')),1,333) AS FXYJXH, --风险预警信号
           SUBSTRB(TRIM(REPLACE(REPLACE(A.FOC_EVT,CHR(10),''),CHR(13),'')),1,333) AS GZSJDM,   --关注事件代码*/
           --MOD BY LIP 20240223 参考客户风险的先置空
           NULL                                                        AS FXYJXH,              --风险预警信号
           NULL                                                        AS GZSJDM,              --关注事件代码
           ''                                                          AS BBZ,                 --备注
           V_MONTH_END_DATEID                                          AS CJRQ,                --采集日期
           '000'                                                       AS DEPT_NO,             --部门编号
           '01'                                                        AS SRC_SYS_ID,          --来源系统ID
           '000000'                                                    AS ISSUED_NO,           --填报机构
           ORG.ORG_ID_LEL_0                                            AS ORG_NO,              --报送机构
           CASE WHEN LIST.FLAG = 1 THEN ORG.ORG_ID_LEL_1
                ELSE LIST.REP_ORG_ID
            END                                                        AS ADDRESS,             --归属地
           --E.REL_PSN_CRDL_NO                                           AS CWFZRZJHM_ORIG,    --财务负责人证件号码（脱敏前）
           CASE WHEN (CASE WHEN REGEXP_LIKE(TRIM(E.REL_PSN_CUST_NM),'^([\-]?[0-9])+$') THEN NULL
                           --ELSE TRIM(SUBSTRB(TRIM(CODE2.TAR_VALUE_NAME),1,40))
                           ELSE TRIM(SUBSTRB(TRIM(CODE2.TAR_VALUE_NAME),1,60))--MODIFY BY LIP 20240409 改为UTF-8的长度
                      END) = '无证件'
                 THEN NULL
                 ELSE (CASE WHEN REGEXP_LIKE(TRIM(E.REL_PSN_CUST_NM),'^([\-]?[0-9])+$') THEN NULL
                           ELSE E.REL_PSN_CRDL_NO
                      END)
            END                                                        AS CWFZRZJHM_ORIG,      --财务负责人证件号码（脱敏前）
           --REPLACE(REPLACE(D.REL_PSN_CRDL_NO,CHR(10),''),CHR(13),'')   AS FRDBZJHM_ORIG,       --法人代表证件号码（脱敏前）
           CASE --WHEN TRIM(SUBSTRB(TRIM(CODE1.TAR_VALUE_NAME),1,40)) = '无证件' THEN NULL
                WHEN TRIM(SUBSTRB(TRIM(CODE1.TAR_VALUE_NAME),1,60)) = '无证件' THEN NULL --MODIFY BY LIP 20240409 改为UTF-8的长度
                ELSE REPLACE(REPLACE(D.REL_PSN_CRDL_NO,CHR(10),''),CHR(13),'')
            END                                                        AS FRDBZJHM_ORIG,       --法人代表证件号码（脱敏前）
           CASE WHEN TRIM(A.PBC_NO) IS NOT NULL
                THEN REPLACE(REPLACE(A.PBC_NO,CHR(10),''),CHR(13),'')
                WHEN TRIM(A.PBC_NO) IS NULL AND TRIM(A.FIN_PERMIT_NO) IS NOT NULL
                THEN REPLACE(REPLACE(A.FIN_PERMIT_NO,CHR(10),''),CHR(13),'')
                ELSE NVL(REPLACE(REPLACE(A.CRDL_NO,CHR(10),''),CHR(13),''),CC.MBR_USCC)
            END                                                        AS ZJHM_ORIG,           --证件号码（脱敏前）--ADD BY LIP 20230719
           CASE WHEN LIST.FLAG = 1 THEN B.GSFZJG
                ELSE '9999'
            END                                                           AS GSFZJG            --归属分支机构 --MODIFY BY LIP
      FROM RRP_MDL.M_CUST_CORP_INFO A --对公客户信息
     INNER JOIN RRP_EAST.EAST5_KHXXB KHXXB --通过客户同意编号和证件号码限制有业务数据客户
        ON KHXXB.KHTYBH = A.CUST_ID
      LEFT JOIN RRP_MDL.ORG_CONFIG M --机构映射表
        ON M.ORG_ID = A.ORG_ID
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST B --机构表
        ON B.ORG_ID = NVL(M.ORG_ID1,'800')
       AND B.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.ORG_CONFIG MM --MODIFY BY TANGAN AT 20221210 取基本存款账户开户行号
        ON MM.ORG_ID = A.BSC_ACC_OPEN_BANK_ID
      LEFT JOIN RRP_MDL.M_CUST_CORP_GRP_SUB C --集团客户信息子表
        ON C.CUST_ID = A.CUST_ID
       AND C.DATA_DT = V_P_DATE
      LEFT JOIN (--如果集团客户的证件号为空，则取集团母公司的证件号 modify by tangan at 20221118
                SELECT GRP_CUST_ID,REPLACE(REPLACE(MBR_USCC,CHR(10),''),CHR(13),'') AS MBR_USCC
                      ,ROW_NUMBER() OVER(PARTITION BY GRP_CUST_ID ORDER BY CASE WHEN PAR_CO_FLG = 'Y' THEN 1 ELSE 2 END,MBR_USCC) AS NUM
                  FROM RRP_MDL.M_CUST_CORP_GRPMBR_SUB --集团客户成员子表
                 WHERE DATA_DT = V_P_DATE) CC
        ON CC.GRP_CUST_ID = A.CUST_ID
       AND CC.NUM = 1
      LEFT JOIN RRP_EAST.EAST5_203_DGKHXXB_TMP D --对公客户关联人子表
        ON D.CUST_ID = A.CUST_ID
       AND D.NUM = 1
      LEFT JOIN RRP_EAST.EAST5_203_DGKHXXB_TMP1 E --对公客户关联人子表
        ON E.CUST_ID = A.CUST_ID
       AND E.NUM = 1
      LEFT JOIN RRP_MDL.CODE_MAP CODE --码值配置表
        ON CODE.SRC_VALUE_CODE = A.CRDL_TYP
       AND CODE.SRC_CLASS_CODE = 'C0001' --证件类型
       AND CODE.TAR_CLASS_CODE = 'C0001' --证件类型
       AND CODE.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE1 --码值配置表
        ON CODE1.SRC_VALUE_CODE = D.REL_PSN_CRDL_TYP
       AND CODE1.SRC_CLASS_CODE = 'C0001' --法人代表证件类别
       AND CODE1.TAR_CLASS_CODE = 'C0001' --法人代表证件类别
       AND CODE1.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE2 --码值配置表
        ON CODE2.SRC_VALUE_CODE = E.REL_PSN_CRDL_TYP
       AND CODE2.SRC_CLASS_CODE = 'C0001' --财务负责人证件类别
       AND CODE2.TAR_CLASS_CODE = 'C0001' --财务负责人证件类别
       AND CODE2.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE3 --码值配置表
        ON CODE3.SRC_VALUE_CODE = A.IPO_CO_FLG
       AND CODE3.SRC_CLASS_CODE = 'Z0001' --上市公司标志
       AND CODE3.TAR_CLASS_CODE = 'Z0001' --上市公司标志
       AND CODE3.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE4 --码值配置表
        ON CODE4.SRC_VALUE_CODE = A.CUST_CL
       AND CODE4.SRC_CLASS_CODE = 'C0003' --企业分类
       AND CODE4.TAR_CLASS_CODE = 'C0003' --企业分类
       AND CODE4.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CONFIG_ORG_REL ORG --机构级次关系表
        ON ORG.ORG_ID = B.ORG_ID
      LEFT JOIN RRP_MDL.CONFIG_TABLE_LIST LIST --分行报送报表配置表：记录分行报送的报表范围是全行数据还是本行数据 1 只报分行 0 全表报送
        ON UPPER(LIST.TABLE_NAME) = V_TABLE_NAME
     WHERE A.DATA_DT = V_P_DATE;

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
    SELECT CJRQ,KHTYBH,COUNT(1)
      FROM RRP_EAST.EAST5_203_DGKHXXB T
     WHERE CJRQ = V_P_DATE
     GROUP BY CJRQ,KHTYBH
    HAVING COUNT(1) > 1)
    SELECT NVL(COUNT(1),0) INTO V_COUNT FROM TMP1;

    O_ERRCODE := '0';
    V_ENDTIME := SYSDATE;
    IF V_COUNT > 0 THEN
       O_ERRCODE := '1';
       V_SQLMSG  := 'EAST5_203_DGKHXXB(CJRQ,KHTYBH)数据重复';
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

END ETL_EAST5_203_DGKHXXB;
/

