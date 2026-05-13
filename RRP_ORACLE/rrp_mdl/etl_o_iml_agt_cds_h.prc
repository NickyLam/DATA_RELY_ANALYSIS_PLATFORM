CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_AGT_CDS_H(I_P_DATE IN INTEGER,
                                                O_ERRCODE OUT VARCHAR2
                                                )
  /**************************************************************************
  *  程序名称：ETL_O_IML_AGT_CDS_H
  *  功能描述：大额存单历史
  *  创建日期：20240523
  *  开发人员：YUJINGYI
  *  来源表： IML.V_AGT_CDS_H
  *  目标表： O_IML_AGT_CDS_H
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20240523  YJY     首次创建
  ***************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;               --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_TAB_NAME  VARCHAR2(50) := 'O_IML_AGT_CDS_H'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IML_AGT_CDS_H'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_AGT_CDS_H';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-大额存单历史';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IML_AGT_CDS_H
    (AGT_ID                                  --协议编号            
    ,LP_ID                                   --法人编号            
    ,PRECON_ID                               --预约编号            
    ,PRECON_RGST_DT                          --预约登记日期        
    ,PRECON_OPEN_ACCT_DT                     --预约开户日期        
    ,PRECON_RGST_ACCT_TYPE                   --预约登记账户类型代码
    ,PRECON_ORG                              --预约机构编号        
    ,PRECON_CURR_CD                          --预约币种代码        
    ,PRECON_AMT                              --预约金额            
    ,PD_PROD_PRECON_STATUS_CD                --期次产品预约状态代码
    ,CUST_ID                                 --客户编号            
    ,ACCT_ID                                 --账户编号            
    ,CUST_ACCT_NUM                           --客户账号            
    ,CURR_CD                                 --币种代码            
    ,SUB_ACCT_NUM                            --子账号              
    ,PROD_ID                                 --产品编号            
    ,COMB_PROD_ID                            --组合产品编号        
    ,ACCT_NAME                               --账户名称            
    ,SEQ_NUM                                 --序号                
    ,ON_ACCT_SEQ_NUM                         --挂账序号            
    ,SUPP_ON_ACCT_SUB_SEQ_NUM                --追加挂账子序号      
    ,TRAN_AMT                                --交易金额            
    ,PD_CD                                   --期次编号            
    ,PD_PROD_CATE_CD                         --期次产品类别代码    
    ,PD_ISSUE_AMT                            --期次发行金额        
    ,ISSUE_YEAR                              --发行年度            
    ,ISSUE_BEGIN_DT                          --发行起始日期        
    ,ISSUE_TERMNT_DT                         --发行终止日期        
    ,CHN_ID                                  --渠道编号            
    ,CNTPTY_ACCT_ID                          --对手账户编号        
    ,CNTPTY_CUST_ACCT_NUM                    --对手客户账号        
    ,CNTPTY_ACCT_CURR_CD                     --对手账户币种代码    
    ,CNTPTY_SUB_ACCT_NUM                     --对手子账号          
    ,CNTPTY_PROD_ID                          --对手产品编号        
    ,LMT_ID                                  --限制编号            
    ,VOUCH_NO                                --凭证号码            
    ,AUTO_PAYOFF_FLG                         --自动结清标志        
    ,BANK_INT_INT_RAT                        --行内利率            
    ,EXEC_INT_RAT                            --执行利率            
    ,FLOAT_INT_RAT                           --浮动利率            
    ,INT_RAT_TYPE_CD                         --利率类型代码        
    ,INT_RAT_ADJ_WAY_CD                      --利率调整方式代码    
    ,INT_SET_DAY                             --结息日              
    ,INT_SET_FREQ_CD                         --结息频率代码        
    ,ACCRD_FREQ_PAY_INT_FLG                  --按频率付息标志      
    ,NEXT_INT_SET_DT                         --下一结息日期        
    ,TRAN_REF_NO                             --交易参考号          
    ,TELLER_ID                               --柜员编号            
    ,ACCT_STATUS_CD                          --账户状态代码        
    ,REDEM_DT                                --赎回日期            
    ,EXPECT_REDEM_INT                        --预计赎回利息        
    ,INPWN_FLG                               --质押标志            
    ,WDRAW_WAY_CD                            --支取方式代码        
    ,ACCT_ATTR_CD                            --账户属性代码        
    ,CNTPTY_ACCT_NAME                        --对手账户名称        
    ,POTD_ACCT_ID                            --定期一本通账户编号  
    ,CDS_INT_ACCR_WAY_CD                     --大额存单计息方式代码
    ,SUBSCR_ACCT_ID                          --认购账户编号        
    ,COL_INT_ACCT_ID                         --收息账户编号        
    ,START_DT                                --开始日期            
    ,END_DT                                  --结束日期            
    ,ID_MARK                                 --删除标识            
    ,SRC_TABLE_NAME                          --源表名称            
    ,JOB_CD                                  --任务代码            
    ,ETL_TIMESTAMP                           --数据处理时间    
    ,DEL_DT		                               --删除日期
    ,FAIL_RS_DESCB	                         --失败原因描述
    ,MEMO	                                   --摘要
    ,DEL_AUTH_TELLER_ID	                     --删除授权柜员编号
    ,DEL_TELLER_ID	                         --删除柜员编号
    ,REVO_DT	                               --撤单日期
    ,DEP_CHAR_CD	                           --存款性质代码    
    )
  SELECT AGT_ID                                  --协议编号            
        ,LP_ID                                   --法人编号            
        ,PRECON_ID                               --预约编号            
        ,PRECON_RGST_DT                          --预约登记日期        
        ,PRECON_OPEN_ACCT_DT                     --预约开户日期        
        ,PRECON_RGST_ACCT_TYPE                   --预约登记账户类型代码
        ,PRECON_ORG                              --预约机构编号        
        ,PRECON_CURR_CD                          --预约币种代码        
        ,PRECON_AMT                              --预约金额            
        ,PD_PROD_PRECON_STATUS_CD                --期次产品预约状态代码
        ,CUST_ID                                 --客户编号            
        ,ACCT_ID                                 --账户编号            
        ,CUST_ACCT_NUM                           --客户账号            
        ,CURR_CD                                 --币种代码            
        ,SUB_ACCT_NUM                            --子账号              
        ,PROD_ID                                 --产品编号            
        ,COMB_PROD_ID                            --组合产品编号        
        ,ACCT_NAME                               --账户名称            
        ,SEQ_NUM                                 --序号                
        ,ON_ACCT_SEQ_NUM                         --挂账序号            
        ,SUPP_ON_ACCT_SUB_SEQ_NUM                --追加挂账子序号      
        ,TRAN_AMT                                --交易金额            
        ,PD_CD                                   --期次编号            
        ,PD_PROD_CATE_CD                         --期次产品类别代码    
        ,PD_ISSUE_AMT                            --期次发行金额        
        ,ISSUE_YEAR                              --发行年度            
        ,ISSUE_BEGIN_DT                          --发行起始日期        
        ,ISSUE_TERMNT_DT                         --发行终止日期        
        ,CHN_ID                                  --渠道编号            
        ,CNTPTY_ACCT_ID                          --对手账户编号        
        ,CNTPTY_CUST_ACCT_NUM                    --对手客户账号        
        ,CNTPTY_ACCT_CURR_CD                     --对手账户币种代码    
        ,CNTPTY_SUB_ACCT_NUM                     --对手子账号          
        ,CNTPTY_PROD_ID                          --对手产品编号        
        ,LMT_ID                                  --限制编号            
        ,VOUCH_NO                                --凭证号码            
        ,AUTO_PAYOFF_FLG                         --自动结清标志        
        ,BANK_INT_INT_RAT                        --行内利率            
        ,EXEC_INT_RAT                            --执行利率            
        ,FLOAT_INT_RAT                           --浮动利率            
        ,INT_RAT_TYPE_CD                         --利率类型代码        
        ,INT_RAT_ADJ_WAY_CD                      --利率调整方式代码    
        ,INT_SET_DAY                             --结息日              
        ,INT_SET_FREQ_CD                         --结息频率代码        
        ,ACCRD_FREQ_PAY_INT_FLG                  --按频率付息标志      
        ,NEXT_INT_SET_DT                         --下一结息日期        
        ,TRAN_REF_NO                             --交易参考号          
        ,TELLER_ID                               --柜员编号            
        ,ACCT_STATUS_CD                          --账户状态代码        
        ,REDEM_DT                                --赎回日期            
        ,EXPECT_REDEM_INT                        --预计赎回利息        
        ,INPWN_FLG                               --质押标志            
        ,WDRAW_WAY_CD                            --支取方式代码        
        ,ACCT_ATTR_CD                            --账户属性代码        
        ,CNTPTY_ACCT_NAME                        --对手账户名称        
        ,POTD_ACCT_ID                            --定期一本通账户编号  
        ,CDS_INT_ACCR_WAY_CD                     --大额存单计息方式代码
        ,SUBSCR_ACCT_ID                          --认购账户编号        
        ,COL_INT_ACCT_ID                         --收息账户编号        
        ,START_DT                                --开始日期            
        ,END_DT                                  --结束日期            
        ,ID_MARK                                 --删除标识            
        ,SRC_TABLE_NAME                          --源表名称            
        ,JOB_CD                                  --任务代码            
        ,ETL_TIMESTAMP                           --数据处理时间    
        ,DEL_DT		                               --删除日期
        ,FAIL_RS_DESCB	                         --失败原因描述
        ,MEMO	                                   --摘要
        ,DEL_AUTH_TELLER_ID	                     --删除授权柜员编号
        ,DEL_TELLER_ID	                         --删除柜员编号
        ,REVO_DT	                               --撤单日期
        ,DEP_CHAR_CD	                           --存款性质代码    
    FROM IML.V_AGT_CDS_H  --视图-大额存单历史
   WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
     AND ID_MARK <> 'D';

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME,'', O_ERRCODE);

  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;
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

END ETL_O_IML_AGT_CDS_H;
/

