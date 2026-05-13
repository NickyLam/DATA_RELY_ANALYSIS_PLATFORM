CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_PTY_CORP_CUST_GROUP_INFO_H(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
 /*******************************************************************
  **存储过程详细说明：对公客户集团信息历史
  **存储过程名称：    ETL_O_IML_PTY_CORP_CUST_GROUP_INFO_H
  **存储过程创建日期：20260130
  **存储过程创建人：  YUJINGYI
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：          O_ERRCODE
  ** 修改日期    修改人     修改原因
  ** 20260130    YJY        创建  
  *****************************************************************/
AS
  --定义变量
  V_STEP      INTEGER := '0';             --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_PROC_NAME VARCHAR2(100) := 'ETL_O_IML_PTY_CORP_CUST_GROUP_INFO_H'; --程序名称
  V_SYSTEM    VARCHAR2(30)  := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  --处理参数及月末等判断逻辑
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  --支持重跑
  V_STEP      := 1;
  V_STEP_DESC := '程序跑批开始';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_PTY_CORP_CUST_GROUP_INFO_H';

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --程序业务逻辑处理主体部分
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '数据落地-对公客户集团信息历史';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IML_PTY_CORP_CUST_GROUP_INFO_H NOLOGGING 
    ( PARTY_ID                    --当事人编号
     ,LP_ID                       --法人编号
     ,BELONG_GROUP_ID             --所属集团编号
     ,DATA_SRC_CD                 --数据来源代码
     ,BELONG_GROUP_NAME           --所属集团名称
     ,BELONG_GROUP_ORGNZ_CD       --所属集团组织机构代码
     ,BELONG_GROUP_LOAN_CARD_NO   --所属集团贷款卡号
     ,BELONG_GROUP_RGST_CTY_RG_CD --所属集团注册国家地区代码
     ,BELONG_GROUP_SITE_CD        --所属集团所在地代码
     ,BELONG_GROUP_RGST_ADDR      --所属集团注册地址
     ,GROUP_CORE_MEM_FLG          --集团核心成员标志
     ,BELONG_GROUP_DOM_WORK_ADDR  --所属集团国内办公地址
     ,MEM_TYPE_CD                 --成员类型代码
     ,PARENT_CORP_FLG             --母公司标志
     ,MEM_STATUS_CD               --成员状态代码
     ,USE_FAMILY_EDIT_NUM         --当前使用的家谱版本号
     ,MATN_FAMILY_EDIT_NUM        --当前维护的家谱版本号
     ,START_DT                    --开始时间
     ,END_DT                      --结束时间
     ,ID_MARK                     --增删标志
     ,SRC_TABLE_NAME              --源表名称
     ,JOB_CD                      --任务编码
     ,ETL_TIMESTAMP               --ETL处理时间戳
     ,GROUP_CUST_TYPE_CD          --集团客户类型代码
     ,MEM_CORP_NAME               --成员单位名称
     ,PARENT_MEM_ID               --父成员编号
     ,PARENT_MEM_RELA_TYPE_CD     --父成员关系类型代码
     ,SHARE_RATIO                 --持股比例
     ,CHG_TYPE_CD                 --修订类型代码
     ,RGST_ORG_ID                 --登记机构编号
     ,RGST_TELLER_ID              --登记柜员编号
     ,RGST_DT                     --登记日期
     ,UPDATE_ORG_ID               --更新机构编号
     ,UPDATE_TELLER_ID            --更新柜员编号
     ,FINAL_UPDATE_DT             --最后更新日期
    )
  SELECT
      PARTY_ID                    --当事人编号
     ,LP_ID                       --法人编号
     ,BELONG_GROUP_ID             --所属集团编号
     ,DATA_SRC_CD                 --数据来源代码
     ,BELONG_GROUP_NAME           --所属集团名称
     ,BELONG_GROUP_ORGNZ_CD       --所属集团组织机构代码
     ,BELONG_GROUP_LOAN_CARD_NO   --所属集团贷款卡号
     ,BELONG_GROUP_RGST_CTY_RG_CD --所属集团注册国家地区代码
     ,BELONG_GROUP_SITE_CD        --所属集团所在地代码
     ,BELONG_GROUP_RGST_ADDR      --所属集团注册地址
     ,GROUP_CORE_MEM_FLG          --集团核心成员标志
     ,BELONG_GROUP_DOM_WORK_ADDR  --所属集团国内办公地址
     ,MEM_TYPE_CD                 --成员类型代码
     ,PARENT_CORP_FLG             --母公司标志
     ,MEM_STATUS_CD               --成员状态代码
     ,USE_FAMILY_EDIT_NUM         --当前使用的家谱版本号
     ,MATN_FAMILY_EDIT_NUM        --当前维护的家谱版本号
     ,START_DT                    --开始时间
     ,END_DT                      --结束时间
     ,ID_MARK                     --增删标志
     ,SRC_TABLE_NAME              --源表名称
     ,JOB_CD                      --任务编码
     ,ETL_TIMESTAMP               --ETL处理时间戳
     ,GROUP_CUST_TYPE_CD          --集团客户类型代码
     ,MEM_CORP_NAME               --成员单位名称
     ,PARENT_MEM_ID               --父成员编号
     ,PARENT_MEM_RELA_TYPE_CD     --父成员关系类型代码
     ,SHARE_RATIO                 --持股比例
     ,CHG_TYPE_CD                 --修订类型代码
     ,RGST_ORG_ID                 --登记机构编号
     ,RGST_TELLER_ID              --登记柜员编号
     ,RGST_DT                     --登记日期
     ,UPDATE_ORG_ID               --更新机构编号
     ,UPDATE_TELLER_ID            --更新柜员编号
     ,FINAL_UPDATE_DT             --最后更新日期
    FROM IML.V_PTY_CORP_CUST_GROUP_INFO_H --视图-对公客户集团信息历史
   WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
     AND ID_MARK <> 'D';

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --程序跑批结束记录
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '程序跑批结束';
  V_STARTTIME := SYSDATE;
  ETL_DBMS_STATS(V_P_DATE, 'O_IML_PTY_CORP_CUST_GROUP_INFO_H', '', O_ERRCODE); --表分析
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE,PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');
  
--程序异常处理部分
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG  := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ROLLBACK;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_O_IML_PTY_CORP_CUST_GROUP_INFO_H;
/

