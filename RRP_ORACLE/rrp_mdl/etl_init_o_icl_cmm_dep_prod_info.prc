CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_ICL_CMM_DEP_PROD_INFO(I_P_DATE IN INTEGER,
                                                O_ERRCODE OUT VARCHAR2
                                                )
  /**************************************************************************
  *  程序名称：ETL_INIT_O_ICL_CMM_DEP_PROD_INFO
  *  功能描述：存款产品信息
  *  创建日期：20220611
  *  开发人员：梅炜
  *  来源表：
  *  目标表：  O_ICL_CMM_DEP_PROD_INFO
  *  配置表：  CODE_MAP
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220611  梅炜      首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --

  V_STEP      INTEGER := '0'; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_INIT_O_ICL_CMM_DEP_PROD_INFO'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  V_LAST_DAT  VARCHAR2(8); -- 当月月末
  V_YESTADAY  VARCHAR2(8); -- 上日
  V_MONTH_START_DATE DATE;  --系统时间对应月初日期
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_TABLE_NAME VARCHAR2(100); --表名
BEGIN
V_TABLE_NAME := REPLACE(V_PROC_NAME,'ETL_INIT_','');
--清空表
EXECUTE IMMEDIATE 'TRUNCATE TABLE '|| V_TABLE_NAME;

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  O_ERRCODE := '0';
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写

  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
   -- EXECUTE IMMEDIATE ' TRUNCATE TABLE  O_ICL_CMM_DEP_PROD_INFO ';
  /*-- EXECUTE IMMEDIATE ('ALTER TABLE '||'O_ICL_CMM_DEP_PROD_INFO'||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理*/
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 分区表分区处理 --
 /* V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(V_P_DATE, 'O_ICL_CMM_DEP_PROD_INFO', '1', O_ERRCODE);
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
  */

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-存款产品信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_ICL_CMM_DEP_PROD_INFO
  (
					ETL_DT  --数据日期
					,LP_ID  --法人编号
					,PROD_ID  --产品编号
					,PROD_NAME  --产品名称
					,INTNAL_PROD_ID  --内部产品编号
					,ACCTING_ID  --会计核算编号
					,PROD_CATE_CD  --产品类别代码
					,SELL_OBJ_CD  --销售对象代码
					,DEP_KIND_CD  --存款种类代码
					,CHARGE_EVT_WAY_CD  --收费事件方式代码
					,SUPT_BUY_WAY_CD  --支持购买方式代码
					,STATUS_CD  --状态代码
					,CURR_TYPE_CD  --货币类型代码
					,PROD_MODAL_TRAN_FLG  --产品形态转移标志
					,GL_SYNC_FLG  --总账同步标志
					,PRECON_DRAW_FLG  --预约取款标志
					,OPEN_LMT_FLG  --开户限制标志
					,RELA_VOUCH_FLG  --关联凭证标志
					,ALLOW_ZERO_BAL_FLG  --允许零余额标志
					,REDT_FLG  --转存标志
					,MARGIN_DEP_FLG  --保证金存款标志
					,ALLOW_OD_FLG  --允许透支标志
					,EMPLY_PROD_FLG  --员工产品标志
					,DERIV_PROD_FLG  --衍生产品标志
					,MPR_FLG  --利随本清标志
					,ALLOW_REDEM_FLG  --允许赎回标志
					,ALLOW_TRAN_FLG  --允许转让标志
					,ALLOW_SPEC_COL_INT_FLG  --允许指定收息标志
					,ALLOW_INPWN_FLG  --允许质押标志
					,RENEW_DEP_WAY_CD  --续存方式代码
					,ALLOW_MULTI_SUBSCR_FLG  --允许多次认购标志
					,UNEXP_DRAW_WAY_CD  --提前支取方式代码
					,ALLOW_TRAN_WDRAW_FLG  --允许转帐支取标志
					,ALLOW_WDRAW_CNT  --允许支取次数
					,ALLOW_WDRAW_MAX_AMT  --允许支取最大金额
					,BASE_RAT_ID  --基准利率编号
					,INT_RAT_FILE_TYPE_CD  --利率靠档类型代码
					,BASE_RAT  --基准利率
					,INT_RAT_FLO_VAL  --利率浮动值
					,PAY_INT_FREQ  --付息频率
					,SPREAD_INT_RAT  --推广利率
					,MATN_TELLER_ID  --维护柜员编号
					,MATN_ORG_ID  --维护机构编号
					,EFFECT_DT  --生效日期
					,INVALID_DT  --失效日期
					,VALUE_DT  --起息日期
					,EXP_DT  --到期日期
					,STAT_PROD_SUBSCR_LMT_FLG  --统计产品认购额度标志
					,VALUE_WAY_CD  --起息方式代码
					,PROD_ISSUE_TOT_UPLMI  --产品发行总额上限
					,PROD_ISSUE_TOT_LOLMI  --产品发行总额下限
					,SELL_BEGIN_DT_TM  --销售起始日期时间
					,SELL_TERMNT_DT_TM  --销售终止日期时间
					,APOT_REDEM_DT  --约定赎回日期
					,REDEM_INT_RAT_TYPE  --赎回利率类型
					,INIT_AMT  --起存金额
					,INCREMT_AMT  --增量金额
					,MIN_RETND_AMT  --最小留存金额
					,JOB_CD  --任务代码
					,ETL_TIMESTAMP  --数据处理时间


     )
     SELECT
					ETL_DT  --数据日期
					,LP_ID  --法人编号
					,PROD_ID  --产品编号
					,PROD_NAME  --产品名称
					,INTNAL_PROD_ID  --内部产品编号
					,ACCTING_ID  --会计核算编号
					,PROD_CATE_CD  --产品类别代码
					,SELL_OBJ_CD  --销售对象代码
					,DEP_KIND_CD  --存款种类代码
					,CHARGE_EVT_WAY_CD  --收费事件方式代码
					,SUPT_BUY_WAY_CD  --支持购买方式代码
					,STATUS_CD  --状态代码
					,CURR_TYPE_CD  --货币类型代码
					,PROD_MODAL_TRAN_FLG  --产品形态转移标志
					,GL_SYNC_FLG  --总账同步标志
					,PRECON_DRAW_FLG  --预约取款标志
					,OPEN_LMT_FLG  --开户限制标志
					,RELA_VOUCH_FLG  --关联凭证标志
					,ALLOW_ZERO_BAL_FLG  --允许零余额标志
					,REDT_FLG  --转存标志
					,MARGIN_DEP_FLG  --保证金存款标志
					,ALLOW_OD_FLG  --允许透支标志
					,EMPLY_PROD_FLG  --员工产品标志
					,DERIV_PROD_FLG  --衍生产品标志
					,MPR_FLG  --利随本清标志
					,ALLOW_REDEM_FLG  --允许赎回标志
					,ALLOW_TRAN_FLG  --允许转让标志
					,ALLOW_SPEC_COL_INT_FLG  --允许指定收息标志
					,ALLOW_INPWN_FLG  --允许质押标志
					,RENEW_DEP_WAY_CD  --续存方式代码
					,ALLOW_MULTI_SUBSCR_FLG  --允许多次认购标志
					,UNEXP_DRAW_WAY_CD  --提前支取方式代码
					,ALLOW_TRAN_WDRAW_FLG  --允许转帐支取标志
					,ALLOW_WDRAW_CNT  --允许支取次数
					,ALLOW_WDRAW_MAX_AMT  --允许支取最大金额
					,BASE_RAT_ID  --基准利率编号
					,INT_RAT_FILE_TYPE_CD  --利率靠档类型代码
					,BASE_RAT  --基准利率
					,INT_RAT_FLO_VAL  --利率浮动值
					,PAY_INT_FREQ  --付息频率
					,SPREAD_INT_RAT  --推广利率
					,MATN_TELLER_ID  --维护柜员编号
					,MATN_ORG_ID  --维护机构编号
					,EFFECT_DT  --生效日期
					,INVALID_DT  --失效日期
					,VALUE_DT  --起息日期
					,EXP_DT  --到期日期
					,STAT_PROD_SUBSCR_LMT_FLG  --统计产品认购额度标志
					,VALUE_WAY_CD  --起息方式代码
					,PROD_ISSUE_TOT_UPLMI  --产品发行总额上限
					,PROD_ISSUE_TOT_LOLMI  --产品发行总额下限
					,SELL_BEGIN_DT_TM  --销售起始日期时间
					,SELL_TERMNT_DT_TM  --销售终止日期时间
					,APOT_REDEM_DT  --约定赎回日期
					,REDEM_INT_RAT_TYPE  --赎回利率类型
          ,INIT_AMT  --起存金额
          ,INCREMT_AMT  --增量金额
          ,MIN_RETND_AMT  --最小留存金额
          ,JOB_CD  --任务代码
          ,ETL_TIMESTAMP  --数据处理时间

    FROM ICL.V_CMM_DEP_PROD_INFO@LINK_SIT2   --视图-存款产品信息
    ;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;


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

  END ETL_INIT_O_ICL_CMM_DEP_PROD_INFO;
/

