CREATE OR REPLACE PROCEDURE RRP_EAST.ETL_EAST5_204_DGKHCWXXB(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
/***********************************************************************
 **  存储过程详细说明：对公客户财务信息表
 **  存储过程名称:  ETL_EAST5_204_DGKHCWXXB
 **  存储过程创建日期:2022-03-07
 **  存储过程创建人:蔡正伟
 **  输入参数:   I_P_DATE
 **  输出参数:   O_ERRCODE
 **  返回值:     O_ERRCODE
 **  修改日期      修改人        修改原因
 **  20220424      蔡正伟        修改主表与EAST5_KHXXB 关联条件，增加索引，提高效率
 **  20220524      付善斌        币种码值转换
 **  20220524      付善斌        填报机构源调整
 **  20220601      付善斌        归属机构逻辑添加
 **  20220614      付善斌        重跑时清数逻辑
 **  20220628      LIP           修改日志记录格式，修改字段超长、字段换行问题,将过程改为月批
 **  20230427      LIP           将客户名称全是中文的()改为（）
 **  20260304      LIP           调整当月新增数据的判断字段
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
  V_PROC_NAME        VARCHAR2(100) := UPPER('ETL_EAST5_204_DGKHCWXXB'); --存储过程名称
  V_TABLE_NAME       VARCHAR2(100) := UPPER('EAST5_204_DGKHCWXXB'); --表名称
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
    RRP_EAST.ETL_PARTITION_ADD(V_P_DATE,V_TABLE_NAME,1,O_ERRCODE);
    RRP_EAST.ETL_PARTITION_TRUNCATE(V_P_DATE,V_TABLE_NAME,O_ERRCODE);

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    --程序业务逻辑处理主体部分
    V_STEP := V_STEP + 1;
    V_STEP_DESC := '对公客户财务信息表-插入目标表';
    V_STARTTIME := SYSDATE;
    INSERT INTO RRP_EAST.EAST5_204_DGKHCWXXB(
      RID,         --数据主键
      JRXKZH,      --金融许可证号
      NBJGH,       --内部机构号
      YHJGMC,      --银行机构名称
      CWBBBH,      --财务报表编号
      KHTYBH,      --客户统一编号
      KHMC,        --客户名称
      CWBBRQ,      --财务报表日期
      SFSJ,        --是否审计
      SJJG,        --审计机构
      BBKJ,        --报表口径
      BZ,          --币种
      ZCZE,        --资产总额
      FZZE,        --负债总额
      SQLR,        --税前利润
      SDS,         --所得税
      JLR,         --净利润
      ZYYWSR,      --主营业务收入
      XJLLJE,      --现金流量净额
      YSZK,        --应收账款
      QTYSK,       --其他应收款
      BBZQ,        --报表周期
      BBZ,         --备注
      CJRQ,        --采集日期
      DEPT_NO,     --部门编号
      SRC_SYS_ID,  --来源系统ID
      ISSUED_NO,   --填报机构
      ORG_NO,      --报送机构
      ADDRESS,     --归属地
      GSFZJG       --归属分支机构
      )
    SELECT SYS_GUID()                                                 AS RID,         --数据主键
           C.FIN_PERMIT_NO                                            AS JRXKZH,      --金融许可证号
           C.ORG_ID                                                   AS NBJGH,       --内部机构号
           C.ORG_NM                                                   AS YHJGMC,      --银行机构名称
           A.FIN_RPT_ID                                               AS CWBBBH,      --财务报表编号
           A.CUST_ID                                                  AS KHTYBH,      --客户统一编号
           --B.CUST_NM                                                  AS KHMC,        --客户名称
           --MOD BY LIP 20230427 当对公客户的名称都是中文名时，将其中的()改为（）
           CASE WHEN REGEXP_REPLACE(B.CUST_NM,'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(B.CUST_NM),'(','（'),')','）'),' ','')
                ELSE TRIM(B.CUST_NM)
            END                                                       AS KHMC,        --客户名称
           NVL(A.FIN_RPT_DT, '99991231')                              AS CWBBRQ,      --财务报表日期
           CODE.TAR_VALUE_NAME                                        AS SFSJ,        --是否审计
           TRIM(CASE WHEN CODE.TAR_VALUE_NAME = '否' THEN NULL
                ELSE A.AUDIT_CO_NM
            END)                                                      AS SJJG,        --审计机构
           CODE1.TAR_VALUE_NAME                                       AS BBKJ,        --报表口径
           TRIM(A.CUR)                                                AS BZ,          --币种
           A.AST_TOT_AMT                                              AS ZCZE,        --资产总额
           A.LBY_TOT_AMT                                              AS FZZE,        --负债总额
           A.PRE_TAX_PROFIT                                           AS SQLR,        --税前利润
           A.INCM_TAX                                                 AS SDS,         --所得税
           A.NET_PROFIT                                               AS JLR,         --净利润
           A.MAIN_BIZ_INCOME                                          AS ZYYWSR,      --主营业务收入
           A.CASH_NET_AMT                                             AS XJLLJE,      --现金流量净额
           A.RECV_ACC_VAL                                             AS YSZK,        --应收账款
           A.OTH_RECV                                                 AS QTYSK,       --其他应收款
           CASE WHEN A.RPT_CYC = 'Y' THEN '年报'
                WHEN A.RPT_CYC = 'H' THEN '半年报'
                WHEN A.RPT_CYC = 'Q' THEN '季报'
                WHEN A.RPT_CYC = 'M' THEN '月报'
                WHEN A.RPT_CYC = 'D' THEN '日报'
                ELSE '其他-' || REPLACE(CODE2.TAR_VALUE_NAME,'其他-','')
            END                                                       AS BBZQ,        --报表周期
           ''                                                         AS BBZ,         --备注
           V_MONTH_END_DATEID                                         AS CJRQ,        --采集日期
           '000'                                                      AS DEPT_NO,     --部门编号
           '01'                                                       AS SRC_SYS_ID,  --来源系统ID
           '000000'                                                   AS ISSUED_NO,   --填报机构
           ORG.ORG_ID_LEL_0                                           AS ORG_NO,      --报送机构
           CASE WHEN LIST.FLAG = 1 THEN ORG.ORG_ID_LEL_1
                ELSE LIST.REP_ORG_ID
            END                                                       AS ADDRESS,     --归属地
           CASE WHEN LIST.FLAG = 1 THEN C.GSFZJG
                ELSE '9999'
            END                                                       AS GSFZJG       --归属分支机构 --MODIFY BY LIP
      FROM RRP_MDL.M_CUST_CORP_FIN_SUB A --对公客户财务信息子表
     INNER JOIN RRP_EAST.EAST5_KHXXB KHXXB --通过客户同意编号和证件号码限制有业务数据客户
        ON KHXXB.KHTYBH = A.CUST_ID
      --LEFT JOIN RRP_MDL.M_CUST_CORP_INFO B --对公客户信息
     INNER JOIN RRP_MDL.M_CUST_CORP_INFO B --对公客户信息 --MOD BY LIP 20260202 因上游维护了个人客户进来，限制只要对公客户
        ON B.CUST_ID = A.CUST_ID
       AND B.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.ORG_CONFIG M --机构映射表
        ON M.ORG_ID = B.ORG_ID
     LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST C --机构表
        ON C.ORG_ID = NVL(M.ORG_ID1,'800')
       AND C.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.CODE_MAP CODE --码值配置表
        ON CODE.SRC_VALUE_CODE = A.AUDIT_FLG
       AND CODE.SRC_CLASS_CODE = 'Z0001' --是否审计
       AND CODE.TAR_CLASS_CODE = 'Z0001' --是否审计
       AND CODE.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE1 --码值配置表
        ON CODE1.SRC_VALUE_CODE = A.RPT_CLBR
       AND CODE1.SRC_CLASS_CODE = 'D0126' --报表口径
       AND CODE1.TAR_CLASS_CODE = 'D0126' --报表口径
       AND CODE1.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE2 --码值配置表
        ON CODE2.SRC_VALUE_CODE = A.RPT_CYC
       AND CODE2.SRC_CLASS_CODE = 'D0111' --报表周期
       AND CODE2.TAR_CLASS_CODE = 'D0111' --报表周期
       AND CODE2.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CONFIG_ORG_REL ORG --机构级次关系表
        ON ORG.ORG_ID = C.ORG_ID
      LEFT JOIN RRP_MDL.CONFIG_TABLE_LIST LIST --分行报送报表配置表：记录分行报送的报表范围是全行数据还是本行数据 1 只报分行 0 全表报送
        ON UPPER(LIST.TABLE_NAME) = V_TABLE_NAME
     WHERE (A.INPUT_DT >= TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM'),'YYYYMMDD') --MOD BY LIP 20260304
        OR A.UPDATE_DT >= TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM'),'YYYYMMDD'))--MOD BY LIP 20260417
       --AND A.FIN_RPT_DT >= TO_CHAR(ADD_MONTHS(TO_DATE(V_P_DATE,'YYYYMMDD'),-1),'YYYYMMDD') --ADD BY 20220818 XUCX
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
    SELECT CJRQ,CWBBBH,KHTYBH,CWBBRQ,COUNT(1)
      FROM RRP_EAST.EAST5_204_DGKHCWXXB T
     WHERE CJRQ = V_P_DATE
     GROUP BY CJRQ,CWBBBH,KHTYBH,CWBBRQ
    HAVING COUNT(1) > 1)
    SELECT NVL(COUNT(1),0) INTO V_COUNT FROM TMP1;

    O_ERRCODE := '0';
    V_ENDTIME := SYSDATE;
    IF V_COUNT > 0 THEN
       O_ERRCODE := '1';
       V_SQLMSG  := 'EAST5_204_DGKHCWXXB(CJRQ,CWBBBH,KHTYBH,CWBBRQ)数据重复';
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

END ETL_EAST5_204_DGKHCWXXB;
/

