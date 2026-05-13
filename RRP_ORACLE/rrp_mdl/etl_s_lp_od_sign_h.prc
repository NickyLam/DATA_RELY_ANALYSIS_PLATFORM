CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_S_LP_OD_SIGN_H(I_P_DATE IN INTEGER,
                                                O_ERRCODE OUT VARCHAR2
                                                )
  /**************************************************************************
  *  程序名称：ETL_S_LP_OD_SIGN_H
  *  功能描述：法人透支签约历史
  *  创建日期：20240221
  *  开发人员：卢伟博
  *  来源表：
  *  目标表：  S_LP_OD_SIGN_H
  *  配置表：  CODE_MAP
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20240221  卢伟博      首次创建

  ***************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(100) := 'ETL_S_LP_OD_SIGN_H'; -- 程序名称
  V_P_DATE    VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME   DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(30); -- 来源系统
  --V_LAST_DAT  VARCHAR2(8); -- 当月月末
  --V_YESTADAY  VARCHAR2(8); -- 上日
  --V_MONTH_START_DATE DATE;  --系统时间对应月初日期
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_TAB_NAME  VARCHAR2(100) ;   --表名
  V_PART_NAME VARCHAR2(100);   --分区名
BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR( I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'S_LP_OD_SIGN_H'; --表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE;
  --V_MONTH_START_DATE:= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'), 'MM');

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM S_LP_OD_SIGN_H T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
  /*EXECUTE IMMEDIATE ('ALTER TABLE '||'S_LP_OD_SIGN_H'||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理*/
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 分区表分区处理 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME, '1', O_ERRCODE);
  --删除当前分区数据
  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入法人透支详细信息';
  V_STARTTIME := SYSDATE;
  insert /*+ append */ into S_LP_OD_SIGN_H
	(	 agt_id                   -- 协议编号
		,src_agt_id               -- 源协议编号
		,sub_acct_num             -- 子账号
		,cust_acct_num            -- 客户账号
		,cust_id                  -- 客户编号
		,prod_id                  -- 产品编号
		,agt_status_cd            -- 协议状态代码
		,sign_agt_type_cd         -- 签约协议类型代码
		,comm_fee_coll_way_cd     -- 手续费收取方式代码
		,od_way_cd                -- 透支方式代码
		,effect_dt                -- 生效日期
		,invalid_dt               -- 失效日期
		,curr_cd                  -- 币种代码
		,fee_rat                  -- 费率
		,loan_acct_curr_cd        -- 贷款账户币种代码
		,loan_num                 -- 贷款号
		,loan_acct_id             -- 贷款账户编号
		,loan_prod_id             -- 贷款产品编号
		,loan_acct_seq_num        -- 贷款账户序号
		,od_lmt                   -- 透支额度
		,od_curr_cd               -- 透支币种代码
		,od_free_int_tenor        -- 透支免息期限
		,od_tenor                 -- 透支期限
		,od_tenor_type_cd         -- 透支期限类型代码
		,start_od_amt             -- 起透金额
		,src_table_name           -- 源表名称
		,data_dt                   -- 数据日期
		,etl_timestamp            -- etl处理时间戳
   )
  select t.agt_id               -- 协议编号
		,t.src_agt_id               -- 源协议编号
		,t.sub_acct_num             -- 子账号
		,t.cust_acct_num            -- 客户账号
		,t.cust_id                  -- 客户编号
		,t.prod_id                  -- 产品编号
		,t.agt_status_cd            -- 协议状态代码
		,t.sign_agt_type_cd         -- 签约协议类型代码
		,t.comm_fee_coll_way_cd     -- 手续费收取方式代码
		,t.od_way_cd                -- 透支方式代码
		,to_char(t.effect_dt,'yyyymmdd')                -- 生效日期
		,to_char(t.invalid_dt,'yyyymmdd')               -- 失效日期
		,t.curr_cd                  -- 币种代码
		,t.fee_rat                  -- 费率
		,t.loan_acct_curr_cd        -- 贷款账户币种代码
		,t.loan_num                 -- 贷款号
		,t.loan_acct_id             -- 贷款账户编号
		,t.loan_prod_id             -- 贷款产品编号
		,t.loan_acct_seq_num        -- 贷款账户序号
		,t.od_lmt                   -- 透支额度
		,t.od_curr_cd               -- 透支币种代码
		,t.od_free_int_tenor        -- 透支免息期限
		,t.od_tenor                 -- 透支期限
		,t.od_tenor_type_cd         -- 透支期限类型代码
		,t.start_od_amt             -- 起透金额
		,t.src_table_name           -- 源表名称
    ,V_P_DATE as data_dt -- ETL处理日期
    ,SYSDATE as etl_timestamp -- ETL处理时间
  from iml.agt_lp_od_sign_h t -- 法人透支签约历史
  where  t.START_DT <= to_date(V_P_DATE,'yyyymmdd')
      AND T.END_DT>to_date(V_P_DATE,'yyyymmdd')
;


  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);



  --如需要分析表，请用如下代码 --
  --DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
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

END ETL_S_LP_OD_SIGN_H;
/

