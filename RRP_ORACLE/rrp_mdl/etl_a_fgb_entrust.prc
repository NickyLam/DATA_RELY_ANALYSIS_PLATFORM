CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_A_FGB_ENTRUST
(I_P_DATE IN INTEGER,
 O_ERRCODE OUT VARCHAR2
)
  /**************************************************************************
  *  程序名称：ETL_A_FGB_ENTRUST
  *  功能描述：以借据为粒度，接入委托贷款有关信息。报送范围为个人及对公委托贷款业务，
              包括现金管理项下委托贷款、非现金管理项下委托贷款和公积金委托贷款。
  *  创建日期：20221103
  *  开发人员：徐菲
  *  来源表：
  *  目标表：A_FGB_ENTRUST --委托贷款基表_对公
  *  配置表：CODE_MAP
  *  修改情况：
     序号  修改日期   修改人     修改原因
  *   1    20221103   xufei      首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP       INTEGER := 0;     -- 处理步骤
  V_PROC_NAME  VARCHAR2(30) := 'ETL_A_FGB_ENTRUST';
                                 -- 程序名称
  V_P_DATE     VARCHAR2(8);      -- 跑批数据日期
  V_STARTTIME  DATE;             -- 处理开始时间
  V_ENDTIME    DATE;             -- 处理结束时间
  V_SQLCOUNT   INTEGER := 0;     -- 更新或删除影响的记录数
  V_SQLMSG     VARCHAR2(300);    -- SQL执行描述信息
  V_SYSTEM     VARCHAR2(30);     -- 来源系统
  V_STEP_DESC  VARCHAR2(200);    --任务名称
  --V_MONTH_START_DATE DATE;       --系统时间对应月初日期
  V_TAB_NAME VARCHAR2(100) ; --表名
  V_PART_NAME VARCHAR2(100); --分区名
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE     := TO_CHAR( I_P_DATE);  -- 获取跑批日期
  V_SYSTEM     := '监管报送';           -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME   := 'A_FGB_ENTRUST'; --表名,写目标表表名
  V_PART_NAME  := 'PARTITION_'||V_P_DATE; --V_P_DATE 当前日期

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;

  --DELETE FROM A_FGB_ENTRUST T WHERE T.BGRQ = V_P_DATE;--普通表的重跑处理

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;

  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 分区表分区处理 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;

  ETL_PARTITION_ADD(I_P_DATE, 'A_FGB_ENTRUST', '1', O_ERRCODE);

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '插入主表';
  V_STARTTIME := SYSDATE;

  INSERT /*+APPEND*/ INTO RRP_MDL.A_FGB_ENTRUST NOLOGGING
    (
         BGRQ                --001 报告日期
        ,JYWYM               --002 交易唯一码
        ,KHWYM               --003 客户唯一码
        ,ZWJGBH              --004 机构编号
        ,ZWJGMC              --005 机构名称
        ,WTDKLB              --006 委托贷款类别
        ,SFJRJGWT            --007 是否金融机构委托
        ,SFXJGLXX            --008 是否现金管理项下
        ,TXGMJJXYMLMC        --009 投向国民经济行业门类名称
        ,TJYE                --010 统计余额（元）
        ,WTRJJCF             --011 委托人金融机构类型名称
        ,WTRKHH              --012 委托人客户号
        ,WTRMC               --013 委托人名称
        ,WTDKZJLY            --014 委托贷款资金来源
        ,WTDKLBMC            --015 委托贷款类别名称
        ,ZHWYM               --016 账户唯一码
        ,CUST_NAM            --017 客户中文名称
        ,GRDKYTLB            --018 贷款用途类别
        ,GRDKYTLBMC          --019 贷款用途类别名称
     )
  SELECT A.DATA_DT             AS BGRQ      --001 报告日期
        ,A.RCPT_ID             AS JYWYM     --002 交易唯一码
        ,A.CUST_ID             AS KHWYM     --003 客户唯一码
        ,A.ORG_ID              AS ZWJGBH    --004 机构编号
        ,E.ORG_NM              AS ZWJGMC    --005 机构名称
        ,'不适用'              AS WTDKLB    --006 委托贷款类别   --默认不适用
       -- ,DECODE(B.OUT_BIZ_VRTY,'C0202','是','否')
        ,CASE WHEN A.CONSR_TYP LIKE 'A%'  THEN '是' ELSE '否'  END
                           AS SFJRJGWT   --007 是否金融机构委托  C0202 --金融机构委托贷款，C020302 --其他非金融机构委托贷款
        ,DECODE(B.OUT_BIZ_VRTY,'C0201','是','否')
                               AS SFXJGLXX      --008 是否现金管理项下  --补录 C0201现金管理项下委托贷款
        ,G.SRC_VALUE_NAME      AS TXGMJJXYMLMC  --009 投向国民经济行业门类名称
        ,A.LOAN_BAL *I.EXRT    AS TJYE          --010 统计余额（元）
        ,H.SRC_VALUE_NAME      AS WTRJJCF       --011 委托人金融机构类型名称
        ,A.CONSR_CUST_ID       AS WTRKHH        --012 委托人客户号
        ,D.CUST_NM             AS WTRMC         --013 委托人名称
        ,K.CAP_SRC_CD          AS WTDKZJLY      --014 委托贷款资金来源    --新一代信贷没有该字段，不开发
        ,'不适用'              AS WTDKLBMC      --015 委托贷款类别名称
        ,F.CONT_ID             AS ZHWYM         --016 账户唯一码
        ,C.CUST_NM             AS CUST_NAM      --017 客户中文名称
        ,''                    AS GRDKYTLB      --018 贷款用途类别
        ,A.ENTRS_LOAN_USEAGE   AS GRDKYTLBMC    --019 贷款用途类别名称
   FROM RRP_MDL.S_OUT_DUBILL B --表外业务整合表
  INNER JOIN RRP_MDL.S_LOAN_ENTRS A --委托贷款业务整合表
     ON A.RCPT_ID = B.ACC_ID
    AND A.DATA_DT = V_P_DATE
    AND A.DATA_SRC = '对公贷款'
   LEFT JOIN RRP_MDL.M_CUST_CORP_INFO C --对公客户信息
     ON A.CUST_ID = C.CUST_ID  --借款人客户编号
    AND C.DATA_DT = V_P_DATE
   LEFT JOIN RRP_MDL.M_CUST_CORP_INFO D --对公客户信息
     ON A.CONSR_CUST_ID = D.CUST_ID --委托人客户编号
    AND D.DATA_DT = V_P_DATE
   LEFT JOIN RRP_MDL.M_PUM_ORG_INFO E --机构表
     ON E.ORG_ID = B.ORG_ID
    AND E.DATA_DT = V_P_DATE
   LEFT JOIN RRP_MDL.M_LOAN_IN_DUBILL_INFO F --表内借据信息
     ON B.ACC_ID = F.RCPT_ID
    AND F.DATA_DT = V_P_DATE
    AND F.LOAN_BIZ_TYP = '90' --委托贷款
   LEFT JOIN RRP_MDL.M_LOAN_ENTRS_SUB K  -- 委托贷款子表
     ON A.RCPT_ID = K.RCPT_ID
    AND K.DATA_DT = V_P_DATE
   LEFT JOIN RRP_MDL.CODE_MAP G --码值映射表
     ON SUBSTR(TRIM(A.LOAN_DIR_IDY),1,1) = G.SRC_VALUE_CODE
    AND G.SRC_CLASS_CODE = 'P0003' --行业类别 门类
    AND G.TAR_CLASS_CODE = 'P0003'  --行业类别
    AND G.MOD_FLG = 'EAST'
   LEFT JOIN RRP_MDL.CODE_MAP H --码值映射表
     ON D.FIN_ORG_TYP = H.SRC_VALUE_CODE
    AND H.SRC_CLASS_CODE = 'C0005' --金融机构类型
    AND H.TAR_CLASS_CODE = 'C0005'  --金融机构类型
    AND H.MOD_FLG = 'EAST'
   LEFT JOIN RRP_MDL.M_PUM_EXRT_INFO I  --汇率表
     ON A.BIZ_CUR=I.BASE_CUR
    AND I.CNV_CUR='CNY'
    AND A.DATA_DT=I.DATA_DT
  WHERE B.DATA_DT = V_P_DATE
    AND B.DATA_SRC = '委托贷款'
    AND (A.LOAN_BAL <> 0  --余额>0
             OR
               SUBSTR(F.LOAN_ACT_DSTR_DT,1,4) = SUBSTR(V_P_DATE,1,4)); --当年发放
   COMMIT;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

-- 数据重复校验 --
  WITH TMP1 AS (
    SELECT BGRQ,JYWYM,COUNT(1)
      FROM RRP_MDL.A_FGB_ENTRUST T
     WHERE BGRQ = V_P_DATE
     GROUP BY BGRQ,JYWYM
    HAVING COUNT(1) > 1)
    SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1 ;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE   := '1';
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'数据重复,跑批错误');
     RETURN;
  END IF;


   -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);
--插入过程跑批完成记录表
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;

   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   -- 程序跑批结束记录 --
   V_STEP_DESC := '-- 程序跑批结束 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

   -- 程序异常处理部分 --
   EXCEPTION
     WHEN OTHERS THEN
     V_SQLMSG  := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   ROLLBACK;
     O_ERRCODE := '1';
     V_ENDTIME := SYSDATE;
     V_STEP := V_STEP + 1;
     V_STEP_DESC := '-- 程序跑批异常 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  END ETL_A_FGB_ENTRUST;
/

