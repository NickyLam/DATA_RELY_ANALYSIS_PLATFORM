CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_RDW_RML_R02_CORP_LON_LMT(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_O_RDW_RML_R02_CORP_LON_LMT
  *  功能描述：R02_公司贷款额度
  *  创建日期：20251117
  *  开发人员：于敬艺
  *  来源表： RDW.V_RML_R02_CORP_LON_LMT
  *  目标表： O_RDW_RML_R02_CORP_LON_LMT
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20251117  YJY     首次创建
  *************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_P_DATE    VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME   DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_RDW_RML_R02_CORP_LON_LMT'; -- 程序名称
  V_SYSTEM    VARCHAR2(30):= '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写 -- 来源系统
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期

  -- 支持重跑 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_RDW_RML_R02_CORP_LON_LMT';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-R02_公司贷款额度';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_RDW_RML_R02_CORP_LON_LMT NOLOGGING
    (   CUST_NO              --客户编号
       ,LMT_NO               --额度编号
       ,CURR_CD              --币种代码
       ,APPL_LMT             --申请额度
       ,APPRV_LMT_AMT        --额度批复金额
       ,USED_LMT             --已占用额度
       ,USABLE_LMT           --剩余额度
       ,USEXPOSURE_LMT       --已用敞口
       ,EXPOSURE_LMT         --敞口额度
       ,BUS_BREED_CD         --业务品种代码
       ,LMT_APPRV_DT         --额度批准日期
       ,LMT_MATURE_DT        --额度有效结束日期
       ,LMT_CIRCL_FLG        --额度循环标志
       ,LMT_VALID_FLG        --额度有效标志
       ,GROUP_CRDT_FLG       --集团授信标志
       ,UNSPLIT_LMT_AMT      --未切分额度金额
       ,UNSPLIT_ACCESS_AMT   --未切分且未签订业务合同金额
       ,SPLIT_LMT_NO         --切分额度编号
       ,SPLIT_LMT_FLG        --专项切分额度标志
       ,SPLIT_LMT_AMT        --切分额度金额
       ,SPLIT_LMT_TYPE_CD    --切分额度金额类型代码
       ,SPLIT_LMT_CIRCL_FLG  --切分额度可循环标志
       ,SPLIT_LMT_EFFECT_DT  --切分额度生效日期
       ,SPLIT_LMT_END_DT     --切分额度结束日期
       ,SPLIT_LMT_SURP_AMT   --切分额度剩余未签订合同金额
       ,ETL_DT               --数据日期
       ,SCP_BUS_BREED_ID     --切分额度业务品种
       ,SCP_CURR_CD          --切分币种代码
     )
  SELECT /*+PARALLEL*/
        CUST_NO              --客户编号
       ,LMT_NO               --额度编号
       ,CURR_CD              --币种代码
       ,APPL_LMT             --申请额度
       ,APPRV_LMT_AMT        --额度批复金额
       ,USED_LMT             --已占用额度
       ,USABLE_LMT           --剩余额度
       ,USEXPOSURE_LMT       --已用敞口
       ,EXPOSURE_LMT         --敞口额度
       ,BUS_BREED_CD         --业务品种代码
       ,LMT_APPRV_DT         --额度批准日期
       ,LMT_MATURE_DT        --额度有效结束日期
       ,LMT_CIRCL_FLG        --额度循环标志
       ,LMT_VALID_FLG        --额度有效标志
       ,GROUP_CRDT_FLG       --集团授信标志
       ,UNSPLIT_LMT_AMT      --未切分额度金额
       ,UNSPLIT_ACCESS_AMT   --未切分且未签订业务合同金额
       ,SPLIT_LMT_NO         --切分额度编号
       ,SPLIT_LMT_FLG        --专项切分额度标志
       ,SPLIT_LMT_AMT        --切分额度金额
       ,SPLIT_LMT_TYPE_CD    --切分额度金额类型代码
       ,SPLIT_LMT_CIRCL_FLG  --切分额度可循环标志
       ,SPLIT_LMT_EFFECT_DT  --切分额度生效日期
       ,SPLIT_LMT_END_DT     --切分额度结束日期
       ,SPLIT_LMT_SURP_AMT   --切分额度剩余未签订合同金额
       ,ETL_DT               --数据日期
       ,SCP_BUS_BREED_ID     --切分额度业务品种
       ,SCP_CURR_CD          --切分币种代码
    FROM RDW.V_RML_R02_CORP_LON_LMT   --R02_公司贷款额度_视图
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
       ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   --ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, ‘, O_ERRCODE);

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

  END ETL_O_RDW_RML_R02_CORP_LON_LMT;
/

