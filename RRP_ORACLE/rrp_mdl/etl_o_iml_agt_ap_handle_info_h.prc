CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_AGT_AP_HANDLE_INFO_H(I_P_DATE IN INTEGER,
                                                           O_ERRCODE OUT VARCHAR2
                                                           )
  /**************************************************************************
  *  程序名称：ETL_O_IML_AGT_AP_HANDLE_INFO_H
  *  功能描述：问题资产处置信息历史
  *  创建日期：20230905
  *  开发人员：HULIJUAN
  *  来源表： IML.V_AGT_AP_HANDLE_INFO_H
  *  目标表： O_IML_AGT_AP_HANDLE_INFO_H
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *            1   20230905  HULIJUAN 首次创建
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
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IML_AGT_AP_HANDLE_INFO_H'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.O_IML_AGT_AP_HANDLE_INFO_H T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_AGT_AP_HANDLE_INFO_H';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-问题资产处置信息历史';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IML_AGT_AP_HANDLE_INFO_H
    (AGT_ID                         --协议编号
    ,LP_ID                          --法人编号
    ,PROP_ID                        --方案编号
    ,PROP_NAME                      --方案名称
    ,DEL_FLG                        --删除标志
    ,APEDX_ID                       --附件编号
    ,PROP_KIND_ID                   --方案种类编号
    ,MAIN_DISP_TYPE_CD              --主处置类型代码
    ,DISP_TYPE_CD                   --处置类型代码
    ,SUBRCH_PRVLG_FLG               --分支行权限标志
    ,REPLY_ID                       --批复编号
    ,REPLY_CONTENT_DESCB            --批复内容描述
    ,REPLY_INPUT_DT                 --批复录入日期
    ,APV_STATUS_CD                  --审批状态代码
    ,DISP_AMT                       --处置金额
    ,RPBL_PRIC_AMT                  --应还本金金额
    ,RPBL_IN_BS_INT_AMT             --应还表内利息金额
    ,RPBL_OFF_BS_INT_AMT            --应还表外利息金额
    ,DERATE_PRIC_AMT                --减免本金金额
    ,DERATE_TOT_AMT                 --减免总金额
    ,DERATE_IN_BS_INT_AMT           --减免表内利息金额
    ,DERATE_OFF_BS_INT_AMT          --减免表外利息金额
    ,DERATE_BF_PRIC_BAL             --减免前本金余额
    ,DERATE_BF_IN_BS_OVER_INT_AMT   --减免前表内欠息金额
    ,DERATE_BF_OFF_BS_OVER_INT_AMT  --减免前表外欠息金额
    ,BRWER_CERT_TYPE_CD             --借款人证件类型代码
    ,BRWER_CERT_NO                  --借款人证件号码
    ,PROP_INVO_TRD_CUST_DESCB       --方案涉及第三客户描述
    ,PROP_INVO_TRD_CUST_NAME_COMB   --方案涉及第三客户名称组合
    ,PROP_INVO_TRD_CUST_ID_COMB     --方案涉及第三客户编号组合
    ,RISK_ASSET_COMB                --风险资产组合
    ,PROP_DESCB                     --方案描述
    ,REMARK                         --备注
    ,RGST_TELLER_ID                 --登记柜员编号
    ,RGST_ORG_ID                    --登记机构编号
    ,RGST_DT                        --登记日期
    ,UPDATE_TELLER_ID               --更新柜员编号
    ,UPDATE_ORG_ID                  --更新机构编号
    ,UP_DATE                        --更新日期
    ,START_DT                       --开始时间
    ,END_DT                         --结束时间
    ,ID_MARK                        --增删标志
    ,SRC_TABLE_NAME                 --源表名称
    ,JOB_CD                         --任务编码
    ,ETL_TIMESTAMP                  --ETL处理时间戳
    )
  SELECT AGT_ID                         --协议编号
        ,LP_ID                          --法人编号
        ,PROP_ID                        --方案编号
        ,PROP_NAME                      --方案名称
        ,DEL_FLG                        --删除标志
        ,APEDX_ID                       --附件编号
        ,PROP_KIND_ID                   --方案种类编号
        ,MAIN_DISP_TYPE_CD              --主处置类型代码
        ,DISP_TYPE_CD                   --处置类型代码
        ,SUBRCH_PRVLG_FLG               --分支行权限标志
        ,REPLY_ID                       --批复编号
        ,REPLY_CONTENT_DESCB            --批复内容描述
        ,REPLY_INPUT_DT                 --批复录入日期
        ,APV_STATUS_CD                  --审批状态代码
        ,DISP_AMT                       --处置金额
        ,RPBL_PRIC_AMT                  --应还本金金额
        ,RPBL_IN_BS_INT_AMT             --应还表内利息金额
        ,RPBL_OFF_BS_INT_AMT            --应还表外利息金额
        ,DERATE_PRIC_AMT                --减免本金金额
        ,DERATE_TOT_AMT                 --减免总金额
        ,DERATE_IN_BS_INT_AMT           --减免表内利息金额
        ,DERATE_OFF_BS_INT_AMT          --减免表外利息金额
        ,DERATE_BF_PRIC_BAL             --减免前本金余额
        ,DERATE_BF_IN_BS_OVER_INT_AMT   --减免前表内欠息金额
        ,DERATE_BF_OFF_BS_OVER_INT_AMT  --减免前表外欠息金额
        ,BRWER_CERT_TYPE_CD             --借款人证件类型代码
        ,BRWER_CERT_NO                  --借款人证件号码
        ,PROP_INVO_TRD_CUST_DESCB       --方案涉及第三客户描述
        ,PROP_INVO_TRD_CUST_NAME_COMB   --方案涉及第三客户名称组合
        ,PROP_INVO_TRD_CUST_ID_COMB     --方案涉及第三客户编号组合
        ,RISK_ASSET_COMB                --风险资产组合
        ,PROP_DESCB                     --方案描述
        ,REMARK                         --备注
        ,RGST_TELLER_ID                 --登记柜员编号
        ,RGST_ORG_ID                    --登记机构编号
        ,RGST_DT                        --登记日期
        ,UPDATE_TELLER_ID               --更新柜员编号
        ,UPDATE_ORG_ID                  --更新机构编号
        ,UP_DATE                        --更新日期
        ,START_DT                       --开始时间
        ,END_DT                         --结束时间
        ,ID_MARK                        --增删标志
        ,SRC_TABLE_NAME                 --源表名称
        ,JOB_CD                         --任务编码
        ,ETL_TIMESTAMP                  --ETL处理时间戳
    FROM IML.V_AGT_AP_HANDLE_INFO_H  --视图-问题资产处置信息历史
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
  ETL_DBMS_STATS(V_P_DATE, 'O_IML_AGT_AP_HANDLE_INFO_H', '', O_ERRCODE);

  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;
  -- 程序跑批结束记录 --
  V_STEP_DESC := '-- 程序跑批结束 --';
  O_ERRCODE := 0 ;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

-- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    ROLLBACK;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_O_IML_AGT_AP_HANDLE_INFO_H;
/

