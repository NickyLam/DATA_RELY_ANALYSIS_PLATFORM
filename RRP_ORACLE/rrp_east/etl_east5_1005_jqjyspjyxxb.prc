CREATE OR REPLACE PROCEDURE RRP_EAST.ETL_EAST5_1005_JQJYSPJYXXB(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_EAST5_1005_JQJYSPJYXXB
  *  功能描述：即期及衍生品交易信息表
  *  创建日期：20220713
  *  开发人员：郑经超
  *  来源表： M_EAST_DERIV_CPTL_DTL   即期及衍生品交易信息表
              M_PUM_ORG_INFO_EAST     机构表
              CODE_MAP                码值配置表
              CONFIG_ORG_REL          机构级次关系表
              CONFIG_TABLE_LIST LIST  分行报送报表配置表
  *  目标表： EAST5_1005_JQJYSPJYXXB  即期及衍生品交易信息表
  *
  *  配置表：
  *  修改日期    修改人     修改原因
  *
  ***************************************************************************/
AS
  --定义变量
  V_P_DATE     VARCHAR2(8);               --跑批数据日期
  V_STEP_DESC  VARCHAR2(100);             --处理步骤描述
  V_STARTTIME  DATE := SYSDATE;           --处理开始时间
  V_ENDTIME    DATE := SYSDATE;           --处理结束时间
  V_STEP       INTEGER := 0;              --处理步骤
  V_SQLCOUNT   INTEGER := 0;              --更新或删除影响的记录数
  V_SQLMSG     VARCHAR2(300);             --SQL执行描述信息
  V_LAST_DAT   VARCHAR2(8);               --当月月末
  V_START_DT   VARCHAR2(8);               --当月月初
  V_FREQ_FLAG  VARCHAR2(10);              --跑批频度
  V_PART_NAME  VARCHAR2(100);             --分区名
  V_PROC_NAME  VARCHAR2(30) := UPPER('ETL_EAST5_1005_JQJYSPJYXXB'); --程序名称
  V_TABLE_NAME VARCHAR2(100) := UPPER('EAST5_1005_JQJYSPJYXXB'); --表名称
BEGIN
  --处理参数及月末等判断逻辑
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  O_ERRCODE := '0';
  V_LAST_DAT := TO_CHAR(LAST_DAY(TO_DATE(V_P_DATE,'YYYYMMDD')),'YYYYMMDD'); --当月月底
  V_START_DT := SUBSTR(V_P_DATE,0,6) || '01'; --当月月初
  V_FREQ_FLAG := RRP_EAST.FUN_FREQ(V_P_DATE,V_PROC_NAME); --跑批频度判断
  V_PART_NAME := 'PARTITION_'||V_P_DATE; --V_P_DATE 当前日期

  IF V_FREQ_FLAG = '1' THEN
    --支持重跑
    V_STEP := 1;
    V_STEP_DESC := '程序跑批开始';
    V_STARTTIME := SYSDATE;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    --删除当日分区数据
    V_STEP := 2;
    V_STEP_DESC := '表分区处理';
    V_STARTTIME := SYSDATE;
    ETL_PARTITION_ADD(V_LAST_DAT, V_TABLE_NAME, 1, O_ERRCODE); --新建分区
    ETL_PARTITION_TRUNCATE(V_LAST_DAT, V_TABLE_NAME, O_ERRCODE); --清空当日分区以便重跑

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    V_STEP := 3;
    V_STEP_DESC := '程序加工';
    V_STARTTIME := SYSDATE;
    INSERT INTO RRP_EAST.EAST5_1005_JQJYSPJYXXB(
      RID,         --数据主键
      JRXKZH,      --金融许可证号
      NBJGH,       --内部机构号
      YHJGMC,      --银行机构名称
      JYBH,        --交易编号
      YWPZ,        --业务品种
      JCZCLX,      --基础资产类型
      JCZCMC,      --基础资产名称
      JYLX,        --交易类型
      HYZL,        --合约种类
      JYZT,        --交易状态
      MFMC1,       --买方名称
      MFKHTYBH1,   --买方客户统一编号
      MFMC2,       --卖方名称
      MFKHTYBH2,   --卖方客户统一编号
      JYRQ,        --交易日期
      JYSJ,        --交易时间
      QXRQ,        --起息日期
      DQRQ,        --到期日期
      JZRQ,        --截止日期
      JGPL,        --交割频率
      BDSL,        --标的数量
      BDSLDW,      --标的数量单位
      CJJG,        --成交价格
      CJJGDW,      --成交价格单位
      JYCS,        --交易场所
      JGFS,        --交割方式
      QQLX,        --期权类型
      XQFS,        --行权方式
      XQJG,        --行权价格
      XQJGDW,      --行权价格单位
      BZJBZ,       --保证金标志
      ZXYMC,       --主协议名称
      ZYJYDS,      --中央交易对手
      GZJE,        --估值金额
      GZBZ,        --估值币种
      GZRQ,        --估值日期
      JYYGH,       --交易员工号
      SPRGH,       --审批人工号
      BBZ,         --备注
      CJRQ,        --采集日期
      DEPT_NO,     --部门编号
      SRC_SYS_ID,  --来源系统ID
      ISSUED_NO,   --填报机构
      ORG_NO,      --报送机构
      ADDRESS,     --归属地
      GSFZJG       --归属分支机构
      )
    SELECT SYS_GUID()                                          AS RID,         --数据主键
           B.FIN_PERMIT_NO                                     AS JRXKZH,      --金融许可证号
           NVL(M.ORG_ID1,'800')                                AS NBJGH,       --内部机构号
           B.ORG_NM                                            AS YHJGMC,      --银行机构名称
           A.TRA_ID                                            AS JYBH,        --交易编号
           A.BIZ_VRTY                                          AS YWPZ,        --业务品种
           CODE.TAR_VALUE_NAME                                 AS JCZCLX,      --基础资产类型
           A.BASE_AST_NM                                       AS JCZCMC,      --基础资产名称
           CODE1.TAR_VALUE_NAME                                AS JYLX,        --交易类型
           CODE2.TAR_VALUE_NAME                                AS HYZL,        --合约种类
           CODE3.TAR_VALUE_NAME                                AS JYZT,        --交易状态
           --A.BUYER_NM                                          AS MFMC1,       --买方名称
           --COALESCE(TRIM(CUST1.CUST_NM),TRIM(CUST2.CUST_NM),TRIM(A.BUYER_NM)) AS MFMC1, --买方名称 --MOD BY LHQ 20220314
           --MOD BY LIP 20230506 当对公客户的名称都是中文名时，将其中的()改为（）
           CASE WHEN TRIM(CUST1.CUST_NM) IS NOT NULL
                     AND REGEXP_REPLACE(TRIM(CUST1.CUST_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(CUST1.CUST_NM),'(','（'),')','）'),' ','')
                WHEN TRIM(CUST1.CUST_NM) IS NOT NULL THEN TRIM(CUST1.CUST_NM)
                WHEN TRIM(CUST2.CUST_NM) IS NOT NULL
                     AND REGEXP_REPLACE(TRIM(CUST2.CUST_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(CUST2.CUST_NM),'(','（'),')','）'),' ','')
                WHEN TRIM(CUST2.CUST_NM) IS NOT NULL THEN TRIM(CUST2.CUST_NM)
                WHEN TRIM(A.BUYER_NM) IS NOT NULL
                     AND REGEXP_REPLACE(TRIM(A.BUYER_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(A.BUYER_NM),'(','（'),')','）'),' ','')
                WHEN TRIM(A.BUYER_NM) IS NOT NULL THEN TRIM(CUST1.CUST_NM)
            END                                                AS MFMC1,       --买方名称
           A.BUYER_CUST_ID                                     AS MFKHTYBH1,   --买方客户统一编号
           --A.SELLER_NM                                         AS MFMC2,       --卖方名称
           --MOD BY LIP 20230506 当对公客户的名称都是中文名时，将其中的()改为（）
           CASE WHEN REGEXP_REPLACE(TRIM(A.SELLER_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(A.SELLER_NM),'(','（'),')','）'),' ','')
                ELSE TRIM(A.SELLER_NM)
            END                                                AS MFMC2,       --卖方名称
           TRIM(A.SELLER_CUST_ID)                              AS MFKHTYBH2,   --卖方客户统一编号
           NVL(A.TRA_DT, '99991231')                           AS JYRQ,        --交易日期
           NVL(TO_CHAR(A.TRA_TM, 'HH24MISS'), '000000')        AS JYSJ,        --交易时间
           NVL(A.VAL_DT, '99991231')                           AS QXRQ,        --起息日期
           NVL(A.EXP_DT, '99991231')                           AS DQRQ,        --到期日期
           NVL(A.END_DT, '99991231')                           AS JZRQ,        --截止日期
           A.DELY_FREQ                                         AS JGPL,        --交割频率
           A.ULYG_NUM                                          AS BDSL,        --标的数量
           A.ULYG_NUM_UNIT                                     AS BDSLDW,      --标的数量单位
           A.DEAL_PRC                                          AS CJJG,        --成交价格
           A.DEAL_PRC_UNIT                                     AS CJJGDW,      --成交价格单位
           A.TRA_PLACE                                         AS JYCS,        --交易场所
           CODE4.TAR_VALUE_NAME                                AS JGFS,        --交割方式
           CODE5.TAR_VALUE_NAME                                AS QQLX,        --期权类型
           CODE6.TAR_VALUE_NAME                                AS XQFS,        --行权方式
           A.EXER_PRC                                          AS XQJG,        --行权价格
           A.EXER_PRC_UNIT                                     AS XQJGDW,      --行权价格单位
           CODE7.TAR_VALUE_NAME                                AS BZJBZ,       --保证金标志
           A.PRIM_AGRT_NM                                      AS ZXYMC,       --主协议名称
           A.CNTRL_CNTPR_NM                                    AS ZYJYDS,      --中央交易对手
           A.VALT_AMT                                          AS GZJE,        --估值金额
           A.VALT_CUR                                          AS GZBZ,        --估值币种
           NVL(A.VALT_DT, '99991231')                          AS GZRQ,        --估值日期
           A.TRA_EMP_NO                                        AS JYYGH,       --交易员工号
           --A.APRV_PSN_NO                                       AS SPRGH,       --审批人工号
           CASE WHEN TRIM(A.APRV_PSN_NO) = TRIM(A.TRA_EMP_NO) THEN NULL
                ELSE TRIM(A.APRV_PSN_NO)
            END                                                AS SPRGH,       --审批人工号 --20220913代客部分的经办人与审核人如为同一个人，复核人员取空
           ''                                                  AS BBZ,         --备注
           V_LAST_DAT                                          AS CJRQ,        --采集日期
           '000'                                               AS DEPT_NO,     --部门编号
           '01'                                                AS SRC_SYS_ID,  --来源系统ID
           '000000'                                            AS ISSUED_NO,   --填报机构
           ORG.ORG_ID_LEL_0                                    AS ORG_NO,      --报送机构
           CASE WHEN LIST.FLAG = 1 THEN ORG.ORG_ID_LEL_1
                ELSE LIST.REP_ORG_ID
            END                                                AS ADDRESS,     --归属地
           CASE WHEN LIST.FLAG = 1 THEN B.GSFZJG
                ELSE '9999'
            END                                                AS GSFZJG       --归属分支机构
      FROM RRP_MDL.M_EAST_DERIV_CPTL_DTL A --即期及衍生品交易信息表
      LEFT JOIN RRP_MDL.M_CUST_CORP_INFO CUST1 --对公客户信息表
        ON CUST1.CUST_ID = A.BUYER_CUST_ID
       AND CUST1.DATA_DT = V_P_DATE
      --LEFT JOIN RRP_MDL.M_CUST_IND_INFO CUST2 --个人客户信息表
      LEFT JOIN RRP_EAST.M_CUST_IND_INFO_EAST CUST2 --个人客户信息表
        ON CUST2.CUST_ID = A.BUYER_CUST_ID
       AND CUST2.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.ORG_CONFIG M
        ON M.ORG_ID = A.ORG_ID
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST B --机构表
        ON B.ORG_ID = NVL(M.ORG_ID1,'800')
       AND B.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.CODE_MAP CODE --码值配置表
        ON CODE.SRC_VALUE_CODE = A.BASE_AST_TYP
       AND CODE.SRC_CLASS_CODE = 'D0127' --基础资产类型
       AND CODE.TAR_CLASS_CODE = 'D0127' --基础资产类型
       AND CODE.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE1 --码值配置表
        ON CODE1.SRC_VALUE_CODE = A.TRA_TYP
       AND CODE1.SRC_CLASS_CODE = 'T0034' --交易类型
       AND CODE1.TAR_CLASS_CODE = 'T0034' --交易类型
       AND CODE1.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE2 --码值配置表
        ON CODE2.SRC_VALUE_CODE = A.CONT_CL
       AND CODE2.SRC_CLASS_CODE = 'D0134' --合约种类
       AND CODE2.TAR_CLASS_CODE = 'D0134' --合约种类
       AND CODE2.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE3 --码值配置表
        ON CODE3.SRC_VALUE_CODE = A.TRA_STAT
       AND CODE3.SRC_CLASS_CODE = 'D0135' --交易状态
       AND CODE3.TAR_CLASS_CODE = 'D0135' --交易状态
       AND CODE3.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE4 --码值配置表
        ON CODE4.SRC_VALUE_CODE = A.DELY_MODE
       AND CODE4.SRC_CLASS_CODE = 'D0136' --交割方式
       AND CODE4.TAR_CLASS_CODE = 'D0136' --交割方式
       AND CODE4.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE5 --码值配置表
        ON CODE5.SRC_VALUE_CODE = A.OPTION_TYP
       AND CODE5.SRC_CLASS_CODE = 'D0137' --期权类型
       AND CODE5.TAR_CLASS_CODE = 'D0137' --期权类型
       AND CODE5.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE6 --码值配置表
        ON CODE6.SRC_VALUE_CODE = A.EXER_MODE
       AND CODE6.SRC_CLASS_CODE = 'D0138' --行权方式
       AND CODE6.TAR_CLASS_CODE = 'D0138' --行权方式
       AND CODE6.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE7 --码值配置表
        ON CODE7.SRC_VALUE_CODE = A.MRGN_FLG
       AND CODE7.SRC_CLASS_CODE = 'Z0001' --保证金标志
       AND CODE7.TAR_CLASS_CODE = 'Z0001' --保证金标志
       AND CODE7.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CONFIG_ORG_REL ORG --机构级次关系表
        ON ORG.ORG_ID = B.ORG_ID
      LEFT JOIN RRP_MDL.CONFIG_TABLE_LIST LIST --分行报送报表配置表：记录分行报送的报表范围是全行数据还是本行数据 1 只报分行 0 全表报送
        ON UPPER(LIST.TABLE_NAME) = V_TABLE_NAME
     WHERE /*A.DATA_DT = V_P_DATE
       AND*/ A.DATA_DT <= V_P_DATE
       AND A.DATA_DT >= V_START_DT;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    --表分析
    V_STEP := 4;
    V_STEP_DESC := '表分析';
    V_STARTTIME := SYSDATE;
    RRP_EAST.ETL_DBMS_STATS(V_P_DATE,V_TABLE_NAME,V_PART_NAME,O_ERRCODE);

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');
  END IF;

  V_STEP := 5;
  V_STEP_DESC := '程序结束';
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

END ETL_EAST5_1005_JQJYSPJYXXB;
/

