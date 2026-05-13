CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_IOL_ICMS_ASSET_PRESERVATION_LEDGET(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_INIT_O_IOL_ICMS_ASSET_PRESERVATION_LEDGET
  *  功能描述：资产保全台账
  *  创建日期：20230223
  *  开发人员：梅炜
  *  来源表： IOL.V_WIND_CBONDRATING
  *  目标表： O_IOL_ICMS_ASSET_PRESERVATION_LEDGET
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20230216  梅炜     首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_INIT_O_IOL_ICMS_ASSET_PRESERVATION_LEDGET'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_TABLE_NAME VARCHAR2(100); --表名
BEGIN
V_TABLE_NAME := REPLACE(V_PROC_NAME,'ETL_INIT_','');
--清空表
EXECUTE IMMEDIATE 'TRUNCATE TABLE '|| V_TABLE_NAME;

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写

  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;

 --清理当天数据
  V_STEP_DESC  := '清理当天数据';
   -- EXECUTE IMMEDIATE ' TRUNCATE TABLE RRP_MDL.O_IOL_ICMS_ASSET_PRESERVATION_LEDGET';

  V_STEP_DESC  := '装入目标表';
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_ICMS_ASSET_PRESERVATION_LEDGET NOLOGGING
    (
										SERIALNO  --流水号
										,BRANCHBUSINESSDIVISION  --分行/事业部
										,INPUTORGID  --经办机构名称
										,INPUTUSERID  --客户经理
										,CUSTOMERID  --客户编号
										,DUEBILLID  --借据号
										,CUSTOMERNAME  --客户名称
										,CUSTOMERTYPE  --客户类型
										,INDUSTRY  --行业
										,ENTSCALE  --企业规模
										,ASSETTYPE  --资产类型
										,BEGINRISKCLASSIFY  --年初风险分类
										,FIRSTTIMEDESC  --第一次下调不良时间
										,RISKISOLATIONRESULTS  --风险排查结果
										,IRONRIDETIME  --列入铁骑名单时间
										,HANDLERISKCLASSIFY  --处置时点风险分类
										,HANDLETYPE  --处置（含重组）方式
										,TYPEASSETTRANSFER  --资产转让类型
										,HANDLETIME  --处置（含重组）时间
										,HANDLEBALANCE  --处置金额
										,REPAYMENTRESOURCE  --还款来源
										,HANDLEINTERESTBALANCE  --处置欠息金额
										,HANDLECHARGEDBALANCE  --处置罚息金额
										,HANDLEREINTERESTEDBALANCE  --处置复息金额
										,HANDLESUBSTITUTECUSHION  --处置代垫费用
										,BEFORECLASSIFYRESULT  --变动前五级分类
										,BEFOREBALANCE  --变动前余额
										,AFTERCLASSIFYRESULT  --变动后五级分类
										,CASHOFFDATE  --核销/抵债后收现日期（元）
										,RECOVEROFFBALANCE  --核销/抵债后收回金额（元）
										,NORMALRECOVERBALANCE  --调回正常后收回金额
										,REMARK  --备注
										,START_DT  --开始时间
										,END_DT  --结束时间
										,ID_MARK  --增删标志
										,ETL_TIMESTAMP  --ETL处理时间戳

     )
  SELECT /*+PARALLEL*/
										SERIALNO  --流水号
										,BRANCHBUSINESSDIVISION  --分行/事业部
										,INPUTORGID  --经办机构名称
										,INPUTUSERID  --客户经理
										,CUSTOMERID  --客户编号
										,DUEBILLID  --借据号
										,CUSTOMERNAME  --客户名称
										,CUSTOMERTYPE  --客户类型
										,INDUSTRY  --行业
										,ENTSCALE  --企业规模
										,ASSETTYPE  --资产类型
										,BEGINRISKCLASSIFY  --年初风险分类
										,FIRSTTIMEDESC  --第一次下调不良时间
										,RISKISOLATIONRESULTS  --风险排查结果
										,IRONRIDETIME  --列入铁骑名单时间
										,HANDLERISKCLASSIFY  --处置时点风险分类
										,HANDLETYPE  --处置（含重组）方式
										,TYPEASSETTRANSFER  --资产转让类型
										,HANDLETIME  --处置（含重组）时间
										,HANDLEBALANCE  --处置金额
										,REPAYMENTRESOURCE  --还款来源
										,HANDLEINTERESTBALANCE  --处置欠息金额
										,HANDLECHARGEDBALANCE  --处置罚息金额
										,HANDLEREINTERESTEDBALANCE  --处置复息金额
										,HANDLESUBSTITUTECUSHION  --处置代垫费用
										,BEFORECLASSIFYRESULT  --变动前五级分类
										,BEFOREBALANCE  --变动前余额
										,AFTERCLASSIFYRESULT  --变动后五级分类
										,CASHOFFDATE  --核销/抵债后收现日期（元）
										,RECOVEROFFBALANCE  --核销/抵债后收回金额（元）
										,NORMALRECOVERBALANCE  --调回正常后收回金额
										,REMARK  --备注
										,START_DT  --开始时间
										,END_DT  --结束时间
										,ID_MARK  --增删标志
										,ETL_TIMESTAMP  --ETL处理时间戳

    FROM IOL.V_ICMS_ASSET_PRESERVATION_LEDGET   --主指令表(视图)_视图
 		;

 V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;


   --插入跑批完成记录--
   INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
   VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
   COMMIT;
   -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
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

  END ETL_INIT_O_IOL_ICMS_ASSET_PRESERVATION_LEDGET;
/

