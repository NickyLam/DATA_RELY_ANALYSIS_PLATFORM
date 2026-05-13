CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_M_CPTL_BOND_ISSUE_INFO(I_P_DATE IN INTEGER,
                                                O_ERRCODE OUT VARCHAR2
                                                )
  /**************************************************************************
  *  程序名称：ETL_INIT_M_CPTL_BOND_ISSUE_INFO
  *  功能描述：债券发行信息
  *  创建日期：20220524
  *  开发人员：梅炜
  *  来源表：
  *  目标表：  M_CPTL_BOND_ISSUE_INFO
  *  配置表：  CODE_MAP
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220524  梅炜      首次创建
  *             2    20220830  hulj      重新调整逻辑
  *             3    20221114  hulj      增加数据重复校验
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(100) := 'ETL_INIT_M_CPTL_BOND_ISSUE_INFO'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  --V_LAST_DAT  VARCHAR2(8); -- 当月月末
  --V_YESTADAY  VARCHAR2(8); -- 上日
  V_MONTH_START_DATE DATE;  --系统时间对应月初日期
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_TAB_NAME VARCHAR2(100) ;   --表名
  V_PART_NAME VARCHAR2(100);   --分区名
  V_START_DT CHAR(8) ;       --月初日期
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR( I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'M_CPTL_BOND_ISSUE_INFO'; --表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE;


 -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --判断跑批频度--


  -- 分区表分区处理 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;

  --初始化表增加分区
  V_STEP_DESC := '初始化表增加分区';
  V_START_DT := SUBSTR(V_P_DATE,0,6)||'01';
  WHILE TO_DATE(V_START_DT,'YYYYMMDD') <= TO_DATE(V_P_DATE,'YYYYMMDD')
  LOOP
  ETL_PARTITION_ADD(V_START_DT,V_TAB_NAME, '1', O_ERRCODE);
  V_START_DT := TO_CHAR(TO_DATE(V_START_DT,'YYYYMMDD')  + 1 ,'YYYYMMDD');
  END LOOP;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
  --删除当前分区数据

  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入债券发行信息';
  V_STARTTIME := SYSDATE;
    INSERT INTO RRP_MDL.M_CPTL_BOND_ISSUE_INFO
  (
   DATA_DT           --数据日期
   ,LGL_REP_ID       --法人编号
   ,CUST_ID          --客户编号
   ,ORG_ID           --机构编号
   ,ACC_ID           --账户编号
   ,SEQ_NO           --流水号
   ,ULYG_PROD_ID     --标的产品编号
   ,CUR              --币种
   ,ACC_TYP          --账户类型
   ,BOOK_BAL         --账面余额
   ,GL_CL            --会计分类
   ,VAL_DT           --起息日期
   ,ISU_DT           --发行日期
   ,EXP_DT           --到期日期
   ,RATE_RE_PRC_DT   --利率重新定价日期
   ,INT_CALC_FLG     --计息标志
   ,PBL_INT          --应付利息
   ,BIO_FLG          --境内外标志
   ,FIN_DEBT_SUM_CL  --金融债细类
   ,PERP_DEBT_FLG    --永续债标志
   ,RENEWAL_CNT      --续发次数
   ,BOND_SUR_AMT     --债券剩余金额
   ,BOND_ISU_AMT     --债券发行金额
   ,INT_PAY_MODE     --付息方式
   ,DEPT_LINE        --部门条线
   ,DATA_SRC         --数据来源
    )
  SELECT
   V_P_DATE                              DATA_DT --数据日期
   ,A.LP_ID                              LGL_REP_ID --法人编号
   ,B.ISSUER_CUST_ID                     CUST_ID --客户编号
   ,A.ENTRY_ORG_ID                       ORG_ID --机构编号
   ,A.BOND_ID                            ACC_ID --账户编号
   ,A.BOND_ID                            SEQ_NO --流水号
   ,A.BOND_ID                            ULYG_PROD_ID --标的产品编号
   ,A.CURR_CD                            CUR    --币种
   ,B.ASSET_TYPE_ID                      ACC_TYP  --账户类型
   ,A.CURR_BAL                           BOOK_BAL  --账面余额
   ,A.ASSET_THD_CLS_CD                   GL_CL  --会计分类
   ,TO_CHAR(B.VALUE_DT,'YYYYMMDD')       VAL_DT  --起息日期
   ,TO_CHAR(B.ISSUE_DT,'YYYYMMDD')       ISU_DT  --发行日期
   ,TO_CHAR(B.EXP_DT,'YYYYMMDD')         EXP_DT  --到期日期
   ,TO_CHAR(B.NEXT_REVAL_DT,'YYYYMMDD')  RATE_RE_PRC_DT  --利率重新定价日期  -MODIFY BY MW 20221207
   ,B.ACRU_INT_FLG                       INT_CALC_FLG  --计息标志
   ,B.NEXT_PAY_INT_AMT                   PBL_INT  --应付利息
   ,CASE WHEN B.ISSUE_RG_CD IN ('XXX','CNY') THEN 'Y'
   ELSE 'N' END                        BIO_FLG  --境内外标志
   ,NULL                                 FIN_DEBT_SUM_CL  --金融债细类
   ,B.SUBTN_BOND_FLG                     PERP_DEBT_FLG  --永续债标志
   ,'0'                                 RENEWAL_CNT  --续发次数 20220924 XUXIAOBIN MODIFY
   ,A.CURR_BAL+A.INT_ADJ_AMT             BOND_SUR_AMT  --债券剩余金额
   ,A.HOLD_FAC_VAL                       BOND_ISU_AMT  --债券发行金额
   ,CASE WHEN E.B_INFO_COUPON='505001000' THEN
                    (CASE WHEN E.B_INFO_INTERESTTYPE='501001000' THEN '05'
                          WHEN E.B_INFO_INTERESTTYPE='501002000' THEN '04' END)
               WHEN E.B_INFO_COUPON='505002000' THEN '02'
               WHEN E.B_INFO_COUPON='505003000' THEN '01'
               ELSE '03' END              INT_PAY_MODE  --付息方式
   ,NULL                                  DEPT_LINE  --部门条线
   ,'债券发行'                             DATA_SRC  --数据来源
   FROM RRP_MDL.O_ICL_CMM_CAP_BUS_POST A --资金业务持仓表
   LEFT JOIN RRP_MDL.O_ICL_CMM_BOND_BASIC_INFO B --债券基本信息
      ON A.BOND_ID = B.BOND_ID
      AND A.ETL_DT = B.ETL_DT
   /*LEFT JOIN ( SELECT T.*,ROW_NUMBER() OVER(PARTITION BY S_INFO_WINDCODE ORDER BY IS_FIN_INST DESC ) AS RN
                FROM O_IOL_WIND_CBONDISSUER T)D --中国债券主体表 --mdf by hap 20200928
      ON REGEXP_REPLACE(B.BOND_ID,'[^0-9]','')||'.'|| DECODE(B.BOND_MARKET_TYPE_CD,'XSHG','SH'
                                   ,'XSHE','SZ','X_CNBD','IB','DXFX','IB') = D.S_INFO_WINDCODE
      AND D.RN = 1 */
   LEFT JOIN ( SELECT T.*,ROW_NUMBER() OVER(PARTITION BY S_INFO_WINDCODE ORDER BY B_ISSUE_FIRSTISSUE) AS RN
                FROM O_IOL_WIND_CBONDDESCRIPTION T)E --中国债券基本资料表 --mdf by hap 2021112
      ON REGEXP_REPLACE(B.BOND_ID,'[^0-9]','')||'.'|| DECODE(B.BOND_MARKET_TYPE_CD,'XSHG','SH'
                                   ,'XSHE','SZ','X_CNBD','IB','DXFX','IB') = E.S_INFO_WINDCODE
      --AND E.B_INFO_ISSUERCODE = D.S_INFO_COMPCODE
      AND E.RN = 1
   WHERE A.ASSET_TYPE_NAME like '%债券发行%'
   AND A.ETL_DT = TO_DATE(I_P_DATE,'YYYYMMDD')
      ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

      -- 去掉表的主键，通过语句判断数据是否重复--
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '查询数据是否重复';

  WITH TMP1 AS (
    SELECT DATA_DT, ULYG_PROD_ID,COUNT(1)
      FROM M_CPTL_BOND_ISSUE_INFO T
     WHERE DATA_DT = V_P_DATE
    GROUP BY DATA_DT, ULYG_PROD_ID
    HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1 ;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE   := '1';
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
     RETURN;
  END IF;
  -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);

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
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   ROLLBACK;
     O_ERRCODE := '1';
     V_ENDTIME := SYSDATE;

   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  END ETL_INIT_M_CPTL_BOND_ISSUE_INFO;
/

