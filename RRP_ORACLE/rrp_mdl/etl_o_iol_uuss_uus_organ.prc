CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_UUSS_UUS_ORGAN(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
 /*******************************************************************
  **存储过程详细说明：机构信息表
  **存储过程名称：    ETL_O_IOL_UUSS_UUS_ORGAN
  **存储过程创建日期：20251210
  **存储过程创建人：  YUJINGYI
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：          O_ERRCODE
  ** 修改日期    修改人     修改原因
  ** 20251210    YJY        创建  
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
  V_PROC_NAME VARCHAR2(100) := 'ETL_O_IOL_UUSS_UUS_ORGAN'; --程序名称
  V_SYSTEM    VARCHAR2(30)  := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_UUSS_UUS_ORGAN';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '数据落地-机构信息表';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_UUSS_UUS_ORGAN NOLOGGING 
  (       ORGANCODEKEY          --统一组织机构编码
         ,ORGANCODE             --组织机构编号
         ,ZONENO                --分行号
         ,PBOCFINANCIALCODE     --人民银行金融机构编号
         ,FINANCIALCODE         --金融机构标识码
         ,SWIFTCODE             --SWIFT号码
         ,BANKCODE              --支付系统银行行号
         ,LEGAL                 --法人号
         ,BUSINESSLICENSE       --营业执照号码
         ,ORGANIZATIONCODE      --组织机构代码
         ,TAXID                 --税务登记证号
         ,ORGANCNFULLNAME       --组织机构名称
         ,ORGANCNSHORTNAME      --组织机构简称
         ,ORGANENFULLNAME       --组织机构英文全称
         ,ORGANENSHORTNAME      --组织机构英文简称
         ,ORGANSTATECODE        --机构营业状态
         ,ORGANSTATUS           --机构状态
         ,ORGANFOUNDINGDATE     --机构成立日期
         ,ORGANCLOSEDATE        --机构关闭日期
         ,ORGANTYPE             --组织机构类型
         ,ISST                  --是否为实体机构
         ,ISHS                  --是否为核算机构
         ,ISYY                  --是否为营业机构
         ,ISXZ                  --是否为行政机构
         ,ISZW                  --是否为账务机构
         ,ORGANLEVEL            --组织机构级别代码
         ,LEAFNOTEFLAG          --叶节点标志
         ,XZUPORGANCODE         --行政上级组织机构编码
         ,ZWUPORGANCODE         --账务上级组织机构编码
         ,HSUPORGANCODE         --核算上级组织机构编码
         ,SEQUE                 --机构顺序号
         ,POSTCODE              --邮政编码
         ,COUNTRY               --所在国家
         ,PROVINCE              --所在省/州
         ,CITY                  --所在城市
         ,COUNTY                --所在县/区
         ,ADDRESS               --详细地址
         ,EMAIL                 --电子邮箱
         ,URL                   --网址
         ,COUNTRYCODE           --国际长途区号
         ,AREACODE              --国内长途区号
         ,PHONE                 --电话号码
         ,SUBPHONE              --分机号
         ,SERVICEPHONE          --服务电话
         ,FUNORGAN              --职能机构
         ,FUNDEP                --职能部门
         ,ORDERNO               --显示顺序号
         ,FINANCIALLICNUM       --金融许可证号码
         ,ORGANSYSTEM           --机构关联系统
         ,CBRCFININSTTID        --银监会金融机构编号
         ,UNIONFINANCIALCODE    --银联金融机构编号
         ,WORKSTARTTM           --工作开始时间
         ,WORKENDTM             --工作结束时间
         ,UPDATEDATE            --更新日期
         ,HEADEMPLYID           --负责人员工编号
         ,ISXNHS                --是否为虚拟核算机构
         ,RHREGCODE             --人行地区码
         ,BLNG_CITY_PBC         --所属城市(人行)
         ,BANKCODEPERSON        --支付系统银行行号（用于个人结算账户报送）
         ,NOTE1                 --备用1
         ,NOTE2                 --备用2
         ,NOTE3                 --备用3
         ,NOTE4                 --备用4
         ,NOTE5                 --备用5
         ,NOTE6                 --备用6
         ,NOTE7                 --备用7
         ,NOTE8                 --备用8
         ,NOTE9                 --备用9
         ,NOTE10                --备用10
         ,BBUPORGANCODE         --报表上级机构编号
         ,COUNTYFLAG            --县域机构标识
         ,TECHNOLOGYFLAG        --科技支行标识
         ,SPECIALFLAG           --科技特色支行标识
         ,FINANCEFLAG           --科技金融专营机构标识
         ,FREETRADEFLAG         --自贸区网点标识
         ,BUSITIMEDESC          --网点营业时间说明
         ,BUSISCOPDESC          --主要业务范围说明
         ,START_DT              --开始时间
         ,END_DT                --结束时间
         ,ID_MARK               --增删标志
         ,ETL_TIMESTAMP         --ETL处理时间戳
    )
  SELECT 
        ORGANCODEKEY          --统一组织机构编码
         ,ORGANCODE             --组织机构编号
         ,ZONENO                --分行号
         ,PBOCFINANCIALCODE     --人民银行金融机构编号
         ,FINANCIALCODE         --金融机构标识码
         ,SWIFTCODE             --SWIFT号码
         ,BANKCODE              --支付系统银行行号
         ,LEGAL                 --法人号
         ,BUSINESSLICENSE       --营业执照号码
         ,ORGANIZATIONCODE      --组织机构代码
         ,TAXID                 --税务登记证号
         ,ORGANCNFULLNAME       --组织机构名称
         ,ORGANCNSHORTNAME      --组织机构简称
         ,ORGANENFULLNAME       --组织机构英文全称
         ,ORGANENSHORTNAME      --组织机构英文简称
         ,ORGANSTATECODE        --机构营业状态
         ,ORGANSTATUS           --机构状态
         ,ORGANFOUNDINGDATE     --机构成立日期
         ,ORGANCLOSEDATE        --机构关闭日期
         ,ORGANTYPE             --组织机构类型
         ,ISST                  --是否为实体机构
         ,ISHS                  --是否为核算机构
         ,ISYY                  --是否为营业机构
         ,ISXZ                  --是否为行政机构
         ,ISZW                  --是否为账务机构
         ,ORGANLEVEL            --组织机构级别代码
         ,LEAFNOTEFLAG          --叶节点标志
         ,XZUPORGANCODE         --行政上级组织机构编码
         ,ZWUPORGANCODE         --账务上级组织机构编码
         ,HSUPORGANCODE         --核算上级组织机构编码
         ,SEQUE                 --机构顺序号
         ,POSTCODE              --邮政编码
         ,COUNTRY               --所在国家
         ,PROVINCE              --所在省/州
         ,CITY                  --所在城市
         ,COUNTY                --所在县/区
         ,ADDRESS               --详细地址
         ,EMAIL                 --电子邮箱
         ,URL                   --网址
         ,COUNTRYCODE           --国际长途区号
         ,AREACODE              --国内长途区号
         ,PHONE                 --电话号码
         ,SUBPHONE              --分机号
         ,SERVICEPHONE          --服务电话
         ,FUNORGAN              --职能机构
         ,FUNDEP                --职能部门
         ,ORDERNO               --显示顺序号
         ,FINANCIALLICNUM       --金融许可证号码
         ,ORGANSYSTEM           --机构关联系统
         ,CBRCFININSTTID        --银监会金融机构编号
         ,UNIONFINANCIALCODE    --银联金融机构编号
         ,WORKSTARTTM           --工作开始时间
         ,WORKENDTM             --工作结束时间
         ,UPDATEDATE            --更新日期
         ,HEADEMPLYID           --负责人员工编号
         ,ISXNHS                --是否为虚拟核算机构
         ,RHREGCODE             --人行地区码
         ,BLNG_CITY_PBC         --所属城市(人行)
         ,BANKCODEPERSON        --支付系统银行行号（用于个人结算账户报送）
         ,NOTE1                 --备用1
         ,NOTE2                 --备用2
         ,NOTE3                 --备用3
         ,NOTE4                 --备用4
         ,NOTE5                 --备用5
         ,NOTE6                 --备用6
         ,NOTE7                 --备用7
         ,NOTE8                 --备用8
         ,NOTE9                 --备用9
         ,NOTE10                --备用10
         ,BBUPORGANCODE         --报表上级机构编号
         ,COUNTYFLAG            --县域机构标识
         ,TECHNOLOGYFLAG        --科技支行标识
         ,SPECIALFLAG           --科技特色支行标识
         ,FINANCEFLAG           --科技金融专营机构标识
         ,FREETRADEFLAG         --自贸区网点标识
         ,BUSITIMEDESC          --网点营业时间说明
         ,BUSISCOPDESC          --主要业务范围说明
         ,START_DT              --开始时间
         ,END_DT                --结束时间
         ,ID_MARK               --增删标志
         ,ETL_TIMESTAMP         --ETL处理时间戳
    FROM IOL.V_UUSS_UUS_ORGAN --视图-机构信息表
   WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
     AND ID_MARK <> 'D';

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --程序跑批结束记录
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '程序跑批结束';
  V_STARTTIME := SYSDATE;
  ETL_DBMS_STATS(V_P_DATE, 'O_IOL_UUSS_UUS_ORGAN', '', O_ERRCODE); --表分析
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE,PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

--程序异常处理部分
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG  := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ROLLBACK;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_O_IOL_UUSS_UUS_ORGAN;
/

