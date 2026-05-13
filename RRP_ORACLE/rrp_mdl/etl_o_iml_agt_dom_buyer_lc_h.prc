CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_AGT_DOM_BUYER_LC_H(I_P_DATE IN INTEGER, --跑批日期
                                                                 O_ERRCODE  OUT VARCHAR2 --错误代码
                                                               )
 /*******************************************************************
  **存储过程详细说明：国内买方信用证历史
  **存储过程名称：    ETL_O_IML_AGT_DOM_BUYER_LC_H
  **存储过程创建日期：20250916
  **存储过程创建人：  YUJINGYI
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：          O_ERRCODE
  ** 修改日期    修改人     修改原因
  ** 20250916    YJY        创建  
  ** 20251111    YJY        新增货品名称
  ***************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := '0';             --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_PROC_NAME VARCHAR2(100) := 'ETL_O_IML_AGT_DOM_BUYER_LC_H'; --程序名称
  V_SYSTEM    VARCHAR2(30)  := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_AGT_DOM_BUYER_LC_H';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '数据落地-国内买方信用证历史';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IML_AGT_DOM_BUYER_LC_H NOLOGGING 
  (          AGT_ID              --协议编号
            ,LP_ID               --法人编号
            ,INTNAL_LC_ID        --内部信用证编号
            ,LC_ID               --信用证编号
            ,TRAN_DESCB          --交易描述
            ,BUS_TELLER_ID       --业务柜员编号
            ,SYS_RGST_DT         --系统登记日期
            ,ISSUE_DT            --开证日期
            ,CLOSE_DT            --闭卷日期
            ,CLOSE_TYPE_CD       --闭卷类型代码
            ,ADVISE_BANK_NAME    --通知行名称
            ,FINAL_MODIF_DT      --最后修改日期
            ,MODIF_CNT           --修改次数
            ,APPLIT_NAME         --申请人名称
            ,APPLIT_REF_ID       --申请人参考编号
            ,PAY_WAY_CD          --付款方式代码
            ,BENEFC_NAME         --受益人名称
            ,FEE_SRC_CD          --费用来源代码
            ,CFM_WAY_CD          --保兑方式代码
            ,EXP_DT              --到期日期
            ,PRESENT_SITE        --交单地点
            ,LC_TYPE_CD          --信用证类型代码
            ,M_L_WAY_CD          --溢短装方式代码
            ,M_L_CU_RATIO        --溢短装上浮比例
            ,M_L_LOWER_RATIO     --溢短装下浮比例
            ,SHIPMENT_DT         --装船日期
            ,SHIPMENT_SITE       --装船地点
            ,ACPT_CNT            --承兑次数
            ,VP                  --有效期
            ,BELONG_ORG_ID       --所属机构编号
            ,TRAST_ORG_ID        --办理机构编号
            ,ISSUE_WAY_CD        --开证方式代码
            ,DUBIL_ID            --借据编号
            ,TRAFF_WAY_CD        --运输方式代码
            ,LC_BAL              --信用证余额
            ,OPEN_WAY_CD         --开立方式代码
            ,TRADE_TYPE_CD       --贸易类型代码
            ,CFM_FLG             --保兑标志
            ,PUR_SALE_CONT_ID    --购销合同编号
            ,NEGO_PAY_FLG_CD     --议付标志代码
            ,CONT_CURR_CD        --合同币种代码
            ,CONT_AMT            --合同金额
            ,START_DT            --开始时间
            ,END_DT              --结束时间
            ,ID_MARK             --增删标志
            ,SRC_TABLE_NAME      --源表名称
            ,JOB_CD              --任务编码
            ,ETL_TIMESTAMP       --ETL处理时间戳
            ,PROD_NAME           --货品名称   ADD BY YJY 20251111                    
    )
    SELECT
             AGT_ID              --协议编号
            ,LP_ID               --法人编号
            ,INTNAL_LC_ID        --内部信用证编号
            ,LC_ID               --信用证编号
            ,TRAN_DESCB          --交易描述
            ,BUS_TELLER_ID       --业务柜员编号
            ,SYS_RGST_DT         --系统登记日期
            ,ISSUE_DT            --开证日期
            ,CLOSE_DT            --闭卷日期
            ,CLOSE_TYPE_CD       --闭卷类型代码
            ,ADVISE_BANK_NAME    --通知行名称
            ,FINAL_MODIF_DT      --最后修改日期
            ,MODIF_CNT           --修改次数
            ,APPLIT_NAME         --申请人名称
            ,APPLIT_REF_ID       --申请人参考编号
            ,PAY_WAY_CD          --付款方式代码
            ,BENEFC_NAME         --受益人名称
            ,FEE_SRC_CD          --费用来源代码
            ,CFM_WAY_CD          --保兑方式代码
            ,EXP_DT              --到期日期
            ,PRESENT_SITE        --交单地点
            ,LC_TYPE_CD          --信用证类型代码
            ,M_L_WAY_CD          --溢短装方式代码
            ,M_L_CU_RATIO        --溢短装上浮比例
            ,M_L_LOWER_RATIO     --溢短装下浮比例
            ,SHIPMENT_DT         --装船日期
            ,SHIPMENT_SITE       --装船地点
            ,ACPT_CNT            --承兑次数
            ,VP                  --有效期
            ,BELONG_ORG_ID       --所属机构编号
            ,TRAST_ORG_ID        --办理机构编号
            ,ISSUE_WAY_CD        --开证方式代码
            ,DUBIL_ID            --借据编号
            ,TRAFF_WAY_CD        --运输方式代码
            ,LC_BAL              --信用证余额
            ,OPEN_WAY_CD         --开立方式代码
            ,TRADE_TYPE_CD       --贸易类型代码
            ,CFM_FLG             --保兑标志
            ,PUR_SALE_CONT_ID    --购销合同编号
            ,NEGO_PAY_FLG_CD     --议付标志代码
            ,CONT_CURR_CD        --合同币种代码
            ,CONT_AMT            --合同金额
            ,START_DT            --开始时间
            ,END_DT              --结束时间
            ,ID_MARK             --增删标志
            ,SRC_TABLE_NAME      --源表名称
            ,JOB_CD              --任务编码
            ,ETL_TIMESTAMP       --ETL处理时间戳
            ,PROD_NAME           --货品名称   ADD BY YJY 20251111  
  FROM IML.V_AGT_DOM_BUYER_LC_H --视图-国内买方信用证历史
 WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD') 
   AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
   AND ID_MARK <> 'D';
    
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, 'O_IML_AGT_DOM_BUYER_LC_H', '', O_ERRCODE);

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

END ETL_O_IML_AGT_DOM_BUYER_LC_H;
/

