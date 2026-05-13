CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_UXDS_CORP_BASIC_INFO(I_P_DATE IN INTEGER, --跑批日期
                                                                 O_ERRCODE  OUT VARCHAR2 --错误代码
                                                               )
 /*******************************************************************
  **存储过程详细说明：公司基本资料
  **存储过程名称：    ETL_O_IOL_UXDS_CORP_BASIC_INFO
  **存储过程创建日期：20250916
  **存储过程创建人：  YUJINGYI
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：          O_ERRCODE
  ** 修改日期    修改人     修改原因
  ** 20250916    YJY        创建  
  *****************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := '0';             --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_PROC_NAME VARCHAR2(100) := 'ETL_O_IOL_UXDS_CORP_BASIC_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30)  := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_UXDS_CORP_BASIC_INFO';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '数据落地-公司基本资料';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_UXDS_CORP_BASIC_INFO NOLOGGING 
  (          SEQ                             --记录唯一标识
            ,CTIME                           --记录创建时间
            ,MTIME                           --记录修改时间
            ,RTIME                           --记录通讯到用户端时间
            ,CORP_NATURE                     --企业性质
            ,ORG_CN_INTRODUCTION             --机构简介(中文)
            ,DOMESTIC_LISTING_IDENTIFIER     --境内上市标识.是否发行AB股，用于区分境内上市公司和非上市公司 0：否 1：是
            ,CURRENCY_ENCODE                 --货币编码
            ,ACCOUNTING_FIRM_ID              --会计师事务所id
            ,LAW_FIRM_ID                     --律师事务所id
            ,ORG_ID                          --机构id
            ,ORG_NAME_CN                     --机构名称(中文)
            ,ORG_WEBSITE                     --机构网址
            ,ORG_SHORT_NAME_CN               --机构简称(中文)
            ,STAFF_NUM                       --员工人数
            ,LEGAL_REPRESENTATIVE            --法人代表
            ,REG_ADDRESS_CN                  --注册地址(中文)
            ,ACCOUNTING_FIRM_NAME            --会计师事务所名称
            ,LAW_FIRM_NAME                   --律师事务所名称
            ,CHARGED_ACCOUNTANT              --经办会计师
            ,CHARGED_LAWYER                  --经办律师
            ,DISTRICT_ENCODE                 --地区编码
            ,CN_REGIONAL_IDENTIFIER          --中国地区标识
            ,ORG_CODE                        --组织机构代码
            ,UNIFIED_SOCIAL_CREDIT_CODE      --统一社会信用代码
            ,OFFICE_ADDRESS_CN               --办公地址(中文)
            ,POSTCODE                        --邮政编码
            ,REG_ASSET                       --注册资金，单位：万元
            ,CURRENCY_NAME                   --货币名称
            ,ESTABLISHED_DATE                --成立日期
            ,EMAIL                           --电子信箱
            ,TELEPHONE                       --联系电话
            ,FAX                             --联系传真
            ,MAIN_OPERATION_BUSINESS         --主营业务
            ,OPERATING_SCOPE                 --经营范围
            ,ORG_NAME_EN                     --机构名称(英文)
            ,GENERAL_MANAGER                 --总经理
            ,ORG_SHORT_NAME_EN               --机构简称(英文)
            ,CORP_ED                         --公司终止日期
            ,ANNOUNCEMENT_DATE               --公告日期
            ,BUSINESS_REG_NUM                --工商登记号
            ,TAX_REG_NUM                     --税务登记号
            ,SECRETARY                       --董事会秘书
            ,SEC_REPRESENTATIVE              --证券事务代表
            ,ORG_TYPE                        --机构类别
            ,REG_ADDRESS_EN                  --注册地址(英文)
            ,OFFICE_ADDRESS_EN               --办公地址(英文)
            ,BOARD_MANAGE_ANALYSIS           --董事会经营分析
            ,ESTABLISHMENT_HISTORY           --成立情况与历史沿革
            ,ISVALID                         --是否有效
            ,ETL_DT                          --ETL处理日期
            ,ETL_TIMESTAMP                   --ETL处理时间戳
    )
    SELECT
             SEQ                             --记录唯一标识
            ,CTIME                           --记录创建时间
            ,MTIME                           --记录修改时间
            ,RTIME                           --记录通讯到用户端时间
            ,CORP_NATURE                     --企业性质
            ,ORG_CN_INTRODUCTION             --机构简介(中文)
            ,DOMESTIC_LISTING_IDENTIFIER     --境内上市标识.是否发行AB股，用于区分境内上市公司和非上市公司 0：否 1：是
            ,CURRENCY_ENCODE                 --货币编码
            ,ACCOUNTING_FIRM_ID              --会计师事务所id
            ,LAW_FIRM_ID                     --律师事务所id
            ,ORG_ID                          --机构id
            ,ORG_NAME_CN                     --机构名称(中文)
            ,ORG_WEBSITE                     --机构网址
            ,ORG_SHORT_NAME_CN               --机构简称(中文)
            ,STAFF_NUM                       --员工人数
            ,LEGAL_REPRESENTATIVE            --法人代表
            ,REG_ADDRESS_CN                  --注册地址(中文)
            ,ACCOUNTING_FIRM_NAME            --会计师事务所名称
            ,LAW_FIRM_NAME                   --律师事务所名称
            ,CHARGED_ACCOUNTANT              --经办会计师
            ,CHARGED_LAWYER                  --经办律师
            ,DISTRICT_ENCODE                 --地区编码
            ,CN_REGIONAL_IDENTIFIER          --中国地区标识
            ,ORG_CODE                        --组织机构代码
            ,UNIFIED_SOCIAL_CREDIT_CODE      --统一社会信用代码
            ,OFFICE_ADDRESS_CN               --办公地址(中文)
            ,POSTCODE                        --邮政编码
            ,REG_ASSET                       --注册资金，单位：万元
            ,CURRENCY_NAME                   --货币名称
            ,ESTABLISHED_DATE                --成立日期
            ,EMAIL                           --电子信箱
            ,TELEPHONE                       --联系电话
            ,FAX                             --联系传真
            ,MAIN_OPERATION_BUSINESS         --主营业务
            ,OPERATING_SCOPE                 --经营范围
            ,ORG_NAME_EN                     --机构名称(英文)
            ,GENERAL_MANAGER                 --总经理
            ,ORG_SHORT_NAME_EN               --机构简称(英文)
            ,CORP_ED                         --公司终止日期
            ,ANNOUNCEMENT_DATE               --公告日期
            ,BUSINESS_REG_NUM                --工商登记号
            ,TAX_REG_NUM                     --税务登记号
            ,SECRETARY                       --董事会秘书
            ,SEC_REPRESENTATIVE              --证券事务代表
            ,ORG_TYPE                        --机构类别
            ,REG_ADDRESS_EN                  --注册地址(英文)
            ,OFFICE_ADDRESS_EN               --办公地址(英文)
            ,BOARD_MANAGE_ANALYSIS           --董事会经营分析
            ,ESTABLISHMENT_HISTORY           --成立情况与历史沿革
            ,ISVALID                         --是否有效
            ,ETL_DT                          --ETL处理日期
            ,ETL_TIMESTAMP                   --ETL处理时间戳
  FROM IOL.V_UXDS_CORP_BASIC_INFO --视图-公司基本资料
 WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
    
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, 'O_IOL_UXDS_CORP_BASIC_INFO', '', O_ERRCODE);

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

END ETL_O_IOL_UXDS_CORP_BASIC_INFO;
/

