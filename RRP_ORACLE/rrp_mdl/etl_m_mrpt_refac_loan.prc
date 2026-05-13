CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_MRPT_REFAC_LOAN(I_P_DATE IN INTEGER,
                                                  O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_M_MRPT_REFAC_LOAN
  *  功能描述：支小再贷款明细-手工报表专用
  *  创建日期：20221221
  *  开发人员：CYK
  *  来源表：RRP_MDL.O_ICL_CMM_REFAC_LOAN_ATTACH_INFO 支小再贷款补充信息
             RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO   对公客户基本信息表
             RRP_MDL.O_ICL_CMM_INDV_CUST_BASIC_INFO   个人客户基本信息表
             RRP_MDL.M_CRDT_LMT_INFO 授信额度主表
             RRP_MDL.M_LOAN_IN_DUBILL_INFO  贷款借据信息表
  *  目标表：RRP_MDL.M_MRPT_REFAC_LOAN  支小再贷款明细
  *
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20221221  CYK     首次创建
  *             2    20230703  HYF     增加币种代码
                3    20230907  lwb     新增贷款余额月日均字段
  ***************************************************************************/
  AS
  -- 定义变量 --
  I_STEP        INTEGER := 0;   -- 处理步骤
  I_SQLCOUNT    INTEGER := 0;   -- 更新或删除影响的记录数
  V_STEP_DESC   VARCHAR2(100);  -- 处理步骤描述
  V_PROC_NAME   VARCHAR2(30) := 'ETL_M_MRPT_REFAC_LOAN'; -- 程序名称
  V_P_DATE      VARCHAR2(8);    -- 跑批数据日期
  V_SQLMSG      VARCHAR2(300);  -- SQL执行描述信息
  V_SYSTEM      VARCHAR2(30);   -- 来源系统
  V_SQL         VARCHAR2(2000); -- 动态sql
  V_PART_NAME   VARCHAR2(100);  --分区名称
  V_PART_COUNT  INTEGER;        --分区是否存在
  V_TAB_NAME    VARCHAR2(100);  --表名称
  D_STARTTIME   DATE;
  V_FREQ_FLAG   VARCHAR2(10);    --跑批频度标识
  
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送';          -- 默认写监管报送系统，有真实来源的按实际写
  V_PART_NAME := 'PARTITION_'||V_P_DATE; --分区名称
  V_TAB_NAME := 'M_MRPT_REFAC_LOAN'; --表名称
  
/*   --跑批频率
  V_FREQ_FLAG := FUN_FREQ(V_P_DATE, V_PROC_NAME);
  IF V_FREQ_FLAG = '1' THEN*/

  -- 支持重跑 --
  I_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  D_STARTTIME := SYSDATE;

  /*--查询分区是否已经存在
  SELECT COUNT(0)
    INTO V_PART_COUNT
    FROM USER_TAB_PARTITIONS T
   WHERE T.TABLE_NAME = V_TAB_NAME
     AND T.PARTITION_NAME = V_PART_NAME;

  IF V_PART_COUNT = 1 THEN
  V_SQL := 'ALTER TABLE '||V_TAB_NAME||' DROP PARTITION '||V_PART_NAME;--分区表的重跑处理
  EXECUTE IMMEDIATE V_SQL;
  END IF ;*/
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME,1,O_ERRCODE);--新增分区

  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,SYSDATE,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  I_STEP := 2; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入对公信贷数据';
  D_STARTTIME := SYSDATE;

  INSERT  /*+ APPEND */ INTO RRP_MDL.M_MRPT_REFAC_LOAN NOLOGGING
  (
        DATA_DT,                 -- 数据日期
        ORG_ID,                  -- 机构编号
        DUBIL_ID,                -- 借据编号
        CUST_ID,                 -- 客户编号
        CUST_NAME,               -- 客户名称
        CUST_TYPE_CD,            -- 客户类型代码
        LOAN_TYPE_CD,            -- 贷款类型代码
        REFAC_INDUS_TYPE_CD,     -- 支小再行业类型代码
        CORP_SIZE_CD,            -- 企业规模代码
        LAST_YEAR_BUS_INCO,      -- 企业年营业额
        CORP_ASSET_TOT,          -- 资产总额
        CORP_NUMBER,             -- 企业人数
        DRAWDOWN_AMT,            -- 借据金额
        LOAN_ACCT_BAL,           -- 借据余额
        REAL_INT_RAT,            -- 执行利率
        DRAWDOWN_DT,             -- 放款日期
        MATURITY_DT,             -- 约定到期日期
        FINISH_DT,               -- 结清日期
        LOAN_USAGE_DESCB,        -- 贷款用途描述
        GUARANTY_TYP,            -- 担保方式
        LOAN_GRADE_CD,           -- 贷款五级分类代码
        REFAC_AMT,               -- 再贷款金额
        REFAC_CONT_ID,           -- 再贷款合同编号
        REFAC_DISTR_DT,          -- 再贷款发放日期
        REFAC_EXP_DT,            -- 再贷款到期日期
        REFAC_DISTR_MODE_DESCB,  -- 再贷款发放模式描述
        REFAC_KIND_DESCB,        -- 再贷款种类描述
        FACILITY_AMT,            -- 授信额度
        BACKUP_DUBIL_FLG,        -- 补登借据标志
        LEVEL2_BATCH_PKG_ID,     -- 二级批次包编号
        DATA_TYPE,               -- 数据类型
        CUR,                      --币种代码
        M_AVG_BAL                --余额月日均
   )
    SELECT /*+PARALLEL*/
          V_P_DATE                  --数据日期
         ,B.ORG_ID	                --机构编号
         ,A.DUBIL_ID                --借据编号
         ,B.CUST_ID                 --客户编号
         ,C.CUST_NAME               --客户名称
         ,C.CUST_TYPE_CD            --客户类型代码
         ,A.LOAN_TYPE_CD            --贷款类型代码
         ,A.REFAC_INDUS_TYPE_CD     --支小再行业类型代码
         ,A.CORP_SIZE_CD            --企业规模代码
         ,A.LAST_YEAR_BUS_INCO      --企业年营业额
         ,A.CORP_ASSET_TOT          --资产总额
         ,A.CORP_NUMBER             --企业人数
         ,B.LOAN_AMT            --借据金额
         ,B.LOAN_BAL           --借据余额
         ,B.EXEC_RATE            --执行利率
         ,B.LOAN_ACT_DSTR_DT             --放款日期
         ,B.LOAN_ORIG_EXP_DT             --约定到期日期
         ,B.ACT_END_DT               --结清日期
         ,A.LOAN_USAGE_DESCB        --贷款用途描述
         ,B.GUA_MODE                --担保方式
         ,B.LVL5_CL                 --贷款五级分类代码
         ,A.REFAC_AMT               --再贷款金额
         ,A.REFAC_CONT_ID           --再贷款合同编号
         ,TO_CHAR(A.REFAC_DISTR_DT,'YYYYMMDD')REFAC_DISTR_DT  --再贷款发放日期
         ,TO_CHAR(A.REFAC_EXP_DT,'YYYYMMDD')   REFAC_EXP_DT   --再贷款到期日期
         ,A.REFAC_DISTR_MODE_DESCB  --再贷款发放模式描述
         ,A.REFAC_KIND_DESCB        --再贷款种类描述
         ,D.CRDT_TOTAL_LMT         --单户授信总额度
         ,A.BACKUP_DUBIL_FLG         --补登借据标志
         ,A.LEVEL2_BATCH_PKG_ID      --二级批次包编号
         ,B.DATA_SRC                 --数据类型
         ,B.CUR                      --币种代码
         ,TT.M_AVG_BAL                --余额月日均
         FROM RRP_MDL.O_ICL_CMM_REFAC_LOAN_ATTACH_INFO A --支小再贷款补充信息
         LEFT JOIN RRP_MDL.M_LOAN_IN_DUBILL_INFO  B  --贷款借据信息表
         ON  A.DUBIL_ID=B.RCPT_ID
         AND B.DATA_DT=V_P_DATE
         LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO C --对公客户基本信息表
         ON B.CUST_ID=C.CUST_ID
         AND TO_CHAR(C.ETL_DT,'YYYYMMDD')=V_P_DATE
         LEFT JOIN RRP_MDL.M_CRDT_LMT_INFO D  --授信额度主表
         ON B.CUST_ID=D.CUST_ID
         AND D.DATA_DT=V_P_DATE
         LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_ACCT_INFO TT
             ON TT.DUBIL_NUM=A.DUBIL_ID
            AND TT.ETL_DT=TO_DATE(V_P_DATE,'YYYYMMDD')
         WHERE A.REFAC_EXP_DT>TO_DATE(V_P_DATE,'YYYYMMDD')
         AND TO_CHAR(A.ETL_DT,'YYYYMMDD')=V_P_DATE
         AND B.DATA_SRC='对公信贷';

  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := SQLCODE;
  COMMIT;

  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,SYSDATE,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  I_STEP := 3; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入零售贷款数据';
  D_STARTTIME := SYSDATE;

  INSERT  /*+ APPEND */ INTO RRP_MDL.M_MRPT_REFAC_LOAN NOLOGGING
  (
        DATA_DT,                 -- 数据日期
        ORG_ID,                  -- 机构编号
        dubil_id,                -- 借据编号
        cust_id,                 -- 客户编号
        cust_name,               -- 客户名称
        cust_type_cd,            -- 客户类型代码
        loan_type_cd,            -- 贷款类型代码
        refac_indus_type_cd,     -- 支小再行业类型代码
        corp_size_cd,            -- 企业规模代码
        last_year_bus_inco,      -- 企业年营业额
        corp_asset_tot,          -- 资产总额
        corp_number,             -- 企业人数
        drawdown_amt,            -- 借据金额
        loan_acct_bal,           -- 借据余额
        real_int_rat,            -- 执行利率
        drawdown_dt,             -- 放款日期
        maturity_dt,             -- 约定到期日期
        finish_dt,               -- 结清日期
        loan_usage_descb,        -- 贷款用途描述
        guaranty_typ,            -- 担保方式
        loan_grade_cd,           -- 贷款五级分类代码
        refac_amt,               -- 再贷款金额
        refac_cont_id,           -- 再贷款合同编号
        refac_distr_dt,          -- 再贷款发放日期
        refac_exp_dt,            -- 再贷款到期日期
        refac_distr_mode_descb,  -- 再贷款发放模式描述
        refac_kind_descb,        -- 再贷款种类描述
        facility_amt,            -- 授信额度
        backup_dubil_flg,        -- 补登借据标志
        level2_batch_pkg_id,     -- 二级批次包编号
        data_type,               -- 数据类型
        cur   ,                   --币种代码
        m_avg_bal                --余额月日均
   )
    SELECT /*+PARALLEL*/
          V_P_DATE                  --数据日期
         ,K.ORG_ID                  --机构编号
         ,H.DUBIL_ID                --借据编号
         ,K.CUST_ID                 --客户编号
         ,M.CUST_NAME               --客户名称
         ,CASE WHEN M.SM_BUS_OWNER_FLG='1'AND M.INDV_BUS_FLG='0'   THEN 'XW'
               WHEN M.SM_BUS_OWNER_FLG='0'AND M.INDV_BUS_FLG='1'   THEN 'GT'
               WHEN M.SM_BUS_OWNER_FLG='1'AND M.INDV_BUS_FLG='1'   THEN 'XWGT'
          ELSE 'QT'
            END  CUST_TYPE_CD            --客户类型代码
         ,H.LOAN_TYPE_CD            --贷款类型代码
         ,H.REFAC_INDUS_TYPE_CD     --支小再行业类型代码
         ,H.CORP_SIZE_CD            --企业规模代码
         ,H.LAST_YEAR_BUS_INCO       --企业年营业额
         ,H.CORP_ASSET_TOT               --资产总额
         ,H.CORP_NUMBER              --企业人数
         ,K.LOAN_AMT               --借据金额
         ,K.LOAN_BAL             --借据余额
         ,K.EXEC_RATE             --执行利率
         ,K.LOAN_ACT_DSTR_DT             --放款日期
         ,K.LOAN_ORIG_EXP_DT          --约定到期日期
         ,K.ACT_END_DT               --结清日期
         ,H.LOAN_USAGE_DESCB        --贷款用途描述
         ,K.GUA_MODE             --担保方式代码
         ,K.LVL5_CL              --贷款五级分类代码
         ,H.REFAC_AMT              --再贷款金额
         ,H.REFAC_CONT_ID          --再贷款合同编号
         ,TO_CHAR(H.REFAC_DISTR_DT,'YYYYMMDD') REFAC_DISTR_DT   --再贷款发放日期
         ,TO_CHAR(H.REFAC_EXP_DT,'YYYYMMDD') REFAC_EXP_DT      --再贷款到期日期
         ,H.REFAC_DISTR_MODE_DESCB --再贷款发放模式描述
         ,H.REFAC_KIND_DESCB        --再贷款种类描述
         ,O.CRDT_TOTAL_LMT        --单户授信总额度
         ,H.BACKUP_DUBIL_FLG      --补登借据标志
         ,H.LEVEL2_BATCH_PKG_ID    --二级批次包编号
         ,K.DATA_SRC               --数据类型
         ,K.CUR                    --币种代码
         ,TTT.m_avg_bal                --余额月日均
         FROM  RRP_MDL.O_ICL_CMM_REFAC_LOAN_ATTACH_INFO H --支小再贷款补充信息
         LEFT JOIN RRP_MDL.M_LOAN_IN_DUBILL_INFO   K --贷款借据信息表
         ON  H.DUBIL_ID=K.RCPT_ID
         AND K.DATA_DT=V_P_DATE
         LEFT JOIN RRP_MDL.O_ICL_CMM_INDV_CUST_BASIC_INFO M --个人客户基本信息表
         ON K.CUST_ID=M.CUST_ID
         AND TO_CHAR(M.ETL_DT,'YYYYMMDD')=V_P_DATE
         LEFT JOIN RRP_MDL.M_CRDT_LMT_INFO O  --授信额度主表
           ON K.CUST_ID=O.CUST_ID
          AND O.DATA_DT=V_P_DATE
         left join  rrp_mdl.o_icl_CMM_RETL_LOAN_ACCT_INFO ttt
          on ttt.DUBIL_NUM=h.DUBIL_ID
          and ttt.etl_dt=TO_DATE(V_P_DATE,'YYYYMMDD')
         WHERE H.REFAC_EXP_DT>TO_DATE(V_P_DATE,'YYYYMMDD')
         AND TO_CHAR(H.ETL_DT,'YYYYMMDD')=V_P_DATE
         AND K.DATA_SRC='零售贷款';

  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := SQLCODE;
  COMMIT;

  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,SYSDATE,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --程序结束标记
  I_STEP := 4;
  V_STEP_DESC := '-- 程序跑批结束 --';
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,SYSDATE,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,'');

  --调度依赖存储过程的状态
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;
  
/*  END IF ;*/
  
--异常处理
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    ROLLBACK;
    O_ERRCODE := '1';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,SYSDATE,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_M_MRPT_REFAC_LOAN;
/

