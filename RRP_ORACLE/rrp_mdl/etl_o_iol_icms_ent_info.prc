CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_ICMS_ENT_INFO(I_P_DATE IN INTEGER, --跑批日期
                                                                 O_ERRCODE  OUT VARCHAR2 --错误代码
                                                               )
 /*******************************************************************
  **存储过程详细说明：公司客户基本信息
  **存储过程名称：    ETL_O_IOL_ICMS_ENT_INFO
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
  V_PROC_NAME VARCHAR2(100) := 'ETL_O_IOL_ICMS_ENT_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30)  := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_ICMS_ENT_INFO';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '数据落地-公司客户基本信息';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_ICMS_ENT_INFO NOLOGGING 
  (          BASICBANK              --基本帐户行
            ,BASICACCOUNT           --基本账户账号
            ,MYBANK                 --我行开户行
            ,MYBANKACCOUNT          --我行开户帐号
            ,OTHERBANK              --他行开户行
            ,OTHERBANKACCOUNT       --他行开户帐号
            ,ACCOUNTDATE            --在我行首次开立账户时间
            ,CREDITDATE             --与我行建立信贷关系时间
            ,EVALUATEDATE           --评估日期
            ,REMARK                 --备注
            ,INPUTUSERID            --登记人
            ,INPUTORGID             --登记机构编号
            ,INPUTDATE              --登记日期
            ,UPDATEUSERID           --更新人
            ,UPDATEORGID            --更新机构
            ,UPDATEDATE             --更新日期
            ,SWIFTCODE              --SWIFT代码
            ,FINANCEORGLICENCE      --金融机构许可证
            ,FINANCEORGCODE         --金融机构代码
            ,COUNTRYRISK            --国别风险
            ,CORPID                 --法人编号
            ,CORPORGID              --法人机构编号
            ,REGISTERREGIONCODE     --登记地行政区划代码
            ,ECONOMICTYPE           --经济类型
            ,COUNTRYCODE            --所在国家(地区)
            ,FICTITIOUSPERSON       --法定代表人(姓名)
            ,FICTITIOUSPERSONID     --法定代表人证件号码（事业单位等=身份证号）
            ,LISTINGCORPORNOT       --是否上市公司标志
            ,HASIEBUSINESS          --有无进出口经营项目
            ,REGISTERDATE           --注册日期
            ,MCOMPANYNAME           --母公司名称
            ,MCOMPANYCERTTYPE       --母公司证件类型
            ,MCOMPANYCERTID         --母公司证件号码
            ,FIRSTLOANDATE          --首贷日期
            ,SUBJECTBUSINESS        --主营业务
            ,INDUSTRYTYPEFORRS      --所属行业类型
            ,STRATEGICEMERGINGINDUSTRYTYPE      --战略新兴产业类型
            ,CORPORATIONGROWTHSTAGE --企业成长阶段
            ,ORGANIZTYPE            --组织机构类别
            ,ORGDETAIL              --组织机构类别细分
            ,IFOVERSEA              --是否离岸户
            ,RWACUSTOMERTYPE        --加权风险资产客户分类
            ,ISNEWSETUP             --是否为新建企业
            ,PRIVATEENT             --是否民营企业
            ,BANKINGSUPERVISION     --是否银监小企业
            ,BANKINGTYPE            --银监小企业规模
            ,ISDEBT                 --是否为逃废债企业
            ,ISLIMIT                --是否属于两高行业
            ,LABORINTENSIVEENTFLAG  --是否劳动密集型企业
            ,HOLDINGTYPE            --控股类型
            ,ISCOUNTRYSIDENTERPRISE --农村城市标志
            ,ISBLACK                --是否黑名单客户标志
            ,LOCALITY               --是否我行认定小企业
            ,ISFRESHCUST            --是否绿色信贷标志
            ,LMCREDITTYPE           --客户洗钱风险分类
            ,BUSINESSSTRATEGY       --授信策略
            ,INDUSTRIALRESTRUCTURINGTYPE  --客户产业结构调整类型
            ,TRANSFORMATIONANDUPGRADEID   --工业转型升级标识
            ,ORGSTATUS              --部门状态
            ,ONLYLIMIT              --单一限额
            ,SHAREHOLDERSTRUCTUREDATE     --股东结构对应日期
            ,CLYXCUSTOMERID         --策略营销客户号
            ,CHARGEDEPARTMENT       --上级主管单位
            ,ISRELATIVETRADE        --是否我行关联交易
            ,CORPIDETITYTYPE        --征信报送企业身份标识类型
            ,FUNDSOURCE             --经费来源
            ,FISCALSOURCE           --财政补助收入来源
            ,SERVICEUPDATERESULT    --客户服务升级分类
            ,GOVERNMENTLEVEL        --政府等级
            ,ISRELATEDPARTY         --是否我行关联方标志
            ,MANAGEAREA             --政府机构行政区划
            ,FINANCECORPID          --非现场监管统计机构编码
            ,OTHERORGNAME           --发证机关
            ,CORPSTARTDATE          --发证日期
            ,ISDLFR                 --是否独立法人
            ,ISPART                 --是否我行股东
            ,ISOVERSEAS             --是否海外子行客户
            ,AUTHFLAG               --是否授权
            ,ISINVESTCUST           --是否投资类客户
            ,DISTRIBUTESTATUS       --分配状态
            ,CUSTOMERTYPE           --客户机构类型
            ,IFSME                  --是否中小企业事业部专营客户
            ,FICTITIOUSPERSONCERTIFICATEID      --法定代表人证明书标号
            ,FICTITIOUSMOBILE       --法定代表人移动电话
            ,REGISTERADD            --注册地址
            ,NEWREGIONCODE          --行政区域（风险预警）
            ,FINANCEDIRECTORNAME    --财务总监姓名
            ,MOBILEPHONE            --财务总监移动电话\移动电话
            ,LOANCARDPASSWORD       --贷款卡密码
            ,PROJECTFLAG            --机构目前是否有项目
            ,REALTYFLAG             --是否从事房地产开发
            ,ISSTRATEGYCUSTOMER     --是否战略客户
            ,FINANCEFIAMTEL         --财务负责人家庭电话
            ,FINANCEOTHERTEL        --财务负责人其他电话
            ,ACTUALCONTROLLERCOUNTS --实际控制人个数
            ,INVESTMENCOUNTS        --主要出资人个数
            ,FINANCETYPE2           --金融机构类型
            ,GREENCATEGORY          --绿色贷款用途
            ,GOVERNMENTLTYPE        --政府客户类型
            ,UPBELONGCUSTID         --上级法人机构编号
            ,STATEOWNEDENTHOLDINGFLAG      --是否国企控股
            ,ACCEPTBANKID           --承兑行行号
            ,ACCEPTBANKNAME         --承兑行行名
            ,CREDITINSTITUTIONCODE  --机构信用代码
            ,SOCIETYINSTITUTIONCODE --社会信用代码
            ,RATIFYDATE             --核准日期
            ,COMMERCIALREGISTERNO   --工商注册号
            ,TAXPAYERREGISTERNO     --纳税人识别号
            ,SURVIVALSTATUS         --存续状态
            ,ENVIRONMENTRISKTYPE    --重大环境安全风险分类
            ,MIGTFLAG               --迁移标志：crsrcrilcupl
            ,CORPREGISTERADD        --组织机构代码注册地址
            ,CORPVALIDITYDATE       --组织机构代码有效期
            ,PLATFORMAFFILIATETYPE  --地方融资平台按隶属关系分类类型
            ,PLATFORMLAWTYPE        --地方融资平台按法律性质分类类型
            ,TECHCORPIDENTIFYTIME   --科技型企业认定时间
            ,TECHCORPTYPE           --地方融资平台按隶属关系分类类型
            ,CUSTOMERID             --客户编号
            ,CUSTOMERNAME           --客户名称
            ,ENGLISHNAME            --客户英文名
            ,LICENSENO              --营业执照登记号
            ,LICENSEBEGIN           --证件生效日期
            ,LICENSEMATURITY        --证件失效日期
            ,NATIONALTAXNO          --税务登记证号(国税)
            ,LANDTAXNO              --税务登记证号(地税)
            ,SETUPDATE              --企业成立日期
            ,LOANCARDNO             --中征码
            ,LOANCARDFLAG           --中证码是否有效
            ,SUPERCORPNAME          --上级公司名称
            ,SUPERCERTID            --上级公司组织机构代码
            ,SUPERCERTTYPE          --上级公司证件类型
            ,SUPERLOANCARDNO        --上级公司贷款卡编号
            ,ENTTYPE                --客户类型
            ,ENTSCALE               --企业规模
            ,CALCUENTSCALE          --企业测算规模
            ,ORGTYPE                --组织类型
            ,ORGFORM                --组织形式
            ,ORGBELONG              --机构隶属
            ,INDUSTRYTYPE           --国标行业分类
            ,ECGROUPFLAG            --是否集团客户标志
            ,REGISTERCURRENCY       --注册资本币种
            ,REGISTERAMOUNT         --注册资本
            ,FINANCEDEPTTEL         --财务部联系电话
            ,EMAILADD               --公司E－Mail
            ,FINARUNAREA            --金融机构经营区域范围
            ,FINABRANCHNUM          --金融机构一级分支机构数量
            ,LISTINGCORPTYPE        --上市类型
            ,EMPLOYEENUMBER         --企业员工人数
            ,SALESAMOUNT            --销售收入
            ,GENERALASSETS          --企业总资产总额
            ,ENTINDUSTRYTYPE        --企业行业类型
            ,FINANCETYPE            --同业客户-金融机构类别
            ,BUSINESSSCOPE          --经营范围
            ,CUSTOMERHISTORY        --历史沿革、管理水平简介
            ,IMPORTRIGHTSFLAG       --有无进出口经营权
            ,CREDITLEVEL            --本行即期信用等级
            ,WORKFIELDAREA          --经营场地面积
            ,WORKFIELDFEE           --经营场地所有权
            ,MANAGEINFO             --合法经营情况
            ,MAINPRODUCTION         --主要产品情况
            ,PAIDCURRENCY           --实收币种
            ,PAIDAMOUNT             --实收资本金额
            ,GROUPFLAG              --是否集团标志
            ,ISGOVERNMENTPLARFORM   --是否政府融资平台
            ,MIGTOLDVALUE           --迁移数据-参数转换前字段值
            ,FIRSTLOANFLAG          --首贷标志
            ,ACTUALCONTROLLER       --实际控制人
            ,FRESHXDCATALOG         --绿色信贷细分类目
            ,ISFRESHZQPROJ          --是否绿色债券项目
            ,ADVANCEDMANUFLAG       --先进制造业标志（0-否，1-是）
            ,CULTUREINDUSTRYFLAG    --文化产业标志（0-否，1-是）
            ,ONLYNEWENTFLAG         --专精特新中小企业标志（0-否，1-是）
            ,ONLYNEWSMALLENTFLAG    --专精特新小巨人企业标志（0-否，1-是）
            ,ECODEPARTMENTCODE      --国民经济类型-EcoDepartmentCode
            ,START_DT               --开始时间
            ,END_DT                 --结束时间
            ,ID_MARK                --增删标志
            ,ETL_TIMESTAMP          --ETL处理时间戳
    )
    SELECT
             BASICBANK              --基本帐户行
            ,BASICACCOUNT           --基本账户账号
            ,MYBANK                 --我行开户行
            ,MYBANKACCOUNT          --我行开户帐号
            ,OTHERBANK              --他行开户行
            ,OTHERBANKACCOUNT       --他行开户帐号
            ,ACCOUNTDATE            --在我行首次开立账户时间
            ,CREDITDATE             --与我行建立信贷关系时间
            ,EVALUATEDATE           --评估日期
            ,REMARK                 --备注
            ,INPUTUSERID            --登记人
            ,INPUTORGID             --登记机构编号
            ,INPUTDATE              --登记日期
            ,UPDATEUSERID           --更新人
            ,UPDATEORGID            --更新机构
            ,UPDATEDATE             --更新日期
            ,SWIFTCODE              --SWIFT代码
            ,FINANCEORGLICENCE      --金融机构许可证
            ,FINANCEORGCODE         --金融机构代码
            ,COUNTRYRISK            --国别风险
            ,CORPID                 --法人编号
            ,CORPORGID              --法人机构编号
            ,REGISTERREGIONCODE     --登记地行政区划代码
            ,ECONOMICTYPE           --经济类型
            ,COUNTRYCODE            --所在国家(地区)
            ,FICTITIOUSPERSON       --法定代表人(姓名)
            ,FICTITIOUSPERSONID     --法定代表人证件号码（事业单位等=身份证号）
            ,LISTINGCORPORNOT       --是否上市公司标志
            ,HASIEBUSINESS          --有无进出口经营项目
            ,REGISTERDATE           --注册日期
            ,MCOMPANYNAME           --母公司名称
            ,MCOMPANYCERTTYPE       --母公司证件类型
            ,MCOMPANYCERTID         --母公司证件号码
            ,FIRSTLOANDATE          --首贷日期
            ,SUBJECTBUSINESS        --主营业务
            ,INDUSTRYTYPEFORRS      --所属行业类型
            ,STRATEGICEMERGINGINDUSTRYTYPE      --战略新兴产业类型
            ,CORPORATIONGROWTHSTAGE --企业成长阶段
            ,ORGANIZTYPE            --组织机构类别
            ,ORGDETAIL              --组织机构类别细分
            ,IFOVERSEA              --是否离岸户
            ,RWACUSTOMERTYPE        --加权风险资产客户分类
            ,ISNEWSETUP             --是否为新建企业
            ,PRIVATEENT             --是否民营企业
            ,BANKINGSUPERVISION     --是否银监小企业
            ,BANKINGTYPE            --银监小企业规模
            ,ISDEBT                 --是否为逃废债企业
            ,ISLIMIT                --是否属于两高行业
            ,LABORINTENSIVEENTFLAG  --是否劳动密集型企业
            ,HOLDINGTYPE            --控股类型
            ,ISCOUNTRYSIDENTERPRISE --农村城市标志
            ,ISBLACK                --是否黑名单客户标志
            ,LOCALITY               --是否我行认定小企业
            ,ISFRESHCUST            --是否绿色信贷标志
            ,LMCREDITTYPE           --客户洗钱风险分类
            ,BUSINESSSTRATEGY       --授信策略
            ,INDUSTRIALRESTRUCTURINGTYPE  --客户产业结构调整类型
            ,TRANSFORMATIONANDUPGRADEID   --工业转型升级标识
            ,ORGSTATUS              --部门状态
            ,ONLYLIMIT              --单一限额
            ,SHAREHOLDERSTRUCTUREDATE     --股东结构对应日期
            ,CLYXCUSTOMERID         --策略营销客户号
            ,CHARGEDEPARTMENT       --上级主管单位
            ,ISRELATIVETRADE        --是否我行关联交易
            ,CORPIDETITYTYPE        --征信报送企业身份标识类型
            ,FUNDSOURCE             --经费来源
            ,FISCALSOURCE           --财政补助收入来源
            ,SERVICEUPDATERESULT    --客户服务升级分类
            ,GOVERNMENTLEVEL        --政府等级
            ,ISRELATEDPARTY         --是否我行关联方标志
            ,MANAGEAREA             --政府机构行政区划
            ,FINANCECORPID          --非现场监管统计机构编码
            ,OTHERORGNAME           --发证机关
            ,CORPSTARTDATE          --发证日期
            ,ISDLFR                 --是否独立法人
            ,ISPART                 --是否我行股东
            ,ISOVERSEAS             --是否海外子行客户
            ,AUTHFLAG               --是否授权
            ,ISINVESTCUST           --是否投资类客户
            ,DISTRIBUTESTATUS       --分配状态
            ,CUSTOMERTYPE           --客户机构类型
            ,IFSME                  --是否中小企业事业部专营客户
            ,FICTITIOUSPERSONCERTIFICATEID      --法定代表人证明书标号
            ,FICTITIOUSMOBILE       --法定代表人移动电话
            ,REGISTERADD            --注册地址
            ,NEWREGIONCODE          --行政区域（风险预警）
            ,FINANCEDIRECTORNAME    --财务总监姓名
            ,MOBILEPHONE            --财务总监移动电话\移动电话
            ,LOANCARDPASSWORD       --贷款卡密码
            ,PROJECTFLAG            --机构目前是否有项目
            ,REALTYFLAG             --是否从事房地产开发
            ,ISSTRATEGYCUSTOMER     --是否战略客户
            ,FINANCEFIAMTEL         --财务负责人家庭电话
            ,FINANCEOTHERTEL        --财务负责人其他电话
            ,ACTUALCONTROLLERCOUNTS --实际控制人个数
            ,INVESTMENCOUNTS        --主要出资人个数
            ,FINANCETYPE2           --金融机构类型
            ,GREENCATEGORY          --绿色贷款用途
            ,GOVERNMENTLTYPE        --政府客户类型
            ,UPBELONGCUSTID         --上级法人机构编号
            ,STATEOWNEDENTHOLDINGFLAG      --是否国企控股
            ,ACCEPTBANKID           --承兑行行号
            ,ACCEPTBANKNAME         --承兑行行名
            ,CREDITINSTITUTIONCODE  --机构信用代码
            ,SOCIETYINSTITUTIONCODE --社会信用代码
            ,RATIFYDATE             --核准日期
            ,COMMERCIALREGISTERNO   --工商注册号
            ,TAXPAYERREGISTERNO     --纳税人识别号
            ,SURVIVALSTATUS         --存续状态
            ,ENVIRONMENTRISKTYPE    --重大环境安全风险分类
            ,MIGTFLAG               --迁移标志：crsrcrilcupl
            ,CORPREGISTERADD        --组织机构代码注册地址
            ,CORPVALIDITYDATE       --组织机构代码有效期
            ,PLATFORMAFFILIATETYPE  --地方融资平台按隶属关系分类类型
            ,PLATFORMLAWTYPE        --地方融资平台按法律性质分类类型
            ,TECHCORPIDENTIFYTIME   --科技型企业认定时间
            ,TECHCORPTYPE           --地方融资平台按隶属关系分类类型
            ,CUSTOMERID             --客户编号
            ,CUSTOMERNAME           --客户名称
            ,ENGLISHNAME            --客户英文名
            ,LICENSENO              --营业执照登记号
            ,LICENSEBEGIN           --证件生效日期
            ,LICENSEMATURITY        --证件失效日期
            ,NATIONALTAXNO          --税务登记证号(国税)
            ,LANDTAXNO              --税务登记证号(地税)
            ,SETUPDATE              --企业成立日期
            ,LOANCARDNO             --中征码
            ,LOANCARDFLAG           --中证码是否有效
            ,SUPERCORPNAME          --上级公司名称
            ,SUPERCERTID            --上级公司组织机构代码
            ,SUPERCERTTYPE          --上级公司证件类型
            ,SUPERLOANCARDNO        --上级公司贷款卡编号
            ,ENTTYPE                --客户类型
            ,ENTSCALE               --企业规模
            ,CALCUENTSCALE          --企业测算规模
            ,ORGTYPE                --组织类型
            ,ORGFORM                --组织形式
            ,ORGBELONG              --机构隶属
            ,INDUSTRYTYPE           --国标行业分类
            ,ECGROUPFLAG            --是否集团客户标志
            ,REGISTERCURRENCY       --注册资本币种
            ,REGISTERAMOUNT         --注册资本
            ,FINANCEDEPTTEL         --财务部联系电话
            ,EMAILADD               --公司E－Mail
            ,FINARUNAREA            --金融机构经营区域范围
            ,FINABRANCHNUM          --金融机构一级分支机构数量
            ,LISTINGCORPTYPE        --上市类型
            ,EMPLOYEENUMBER         --企业员工人数
            ,SALESAMOUNT            --销售收入
            ,GENERALASSETS          --企业总资产总额
            ,ENTINDUSTRYTYPE        --企业行业类型
            ,FINANCETYPE            --同业客户-金融机构类别
            ,BUSINESSSCOPE          --经营范围
            ,CUSTOMERHISTORY        --历史沿革、管理水平简介
            ,IMPORTRIGHTSFLAG       --有无进出口经营权
            ,CREDITLEVEL            --本行即期信用等级
            ,WORKFIELDAREA          --经营场地面积
            ,WORKFIELDFEE           --经营场地所有权
            ,MANAGEINFO             --合法经营情况
            ,MAINPRODUCTION         --主要产品情况
            ,PAIDCURRENCY           --实收币种
            ,PAIDAMOUNT             --实收资本金额
            ,GROUPFLAG              --是否集团标志
            ,ISGOVERNMENTPLARFORM   --是否政府融资平台
            ,MIGTOLDVALUE           --迁移数据-参数转换前字段值
            ,FIRSTLOANFLAG          --首贷标志
            ,ACTUALCONTROLLER       --实际控制人
            ,FRESHXDCATALOG         --绿色信贷细分类目
            ,ISFRESHZQPROJ          --是否绿色债券项目
            ,ADVANCEDMANUFLAG       --先进制造业标志（0-否，1-是）
            ,CULTUREINDUSTRYFLAG    --文化产业标志（0-否，1-是）
            ,ONLYNEWENTFLAG         --专精特新中小企业标志（0-否，1-是）
            ,ONLYNEWSMALLENTFLAG    --专精特新小巨人企业标志（0-否，1-是）
            ,ECODEPARTMENTCODE      --国民经济类型-EcoDepartmentCode
            ,START_DT               --开始时间
            ,END_DT                 --结束时间
            ,ID_MARK                --增删标志
            ,ETL_TIMESTAMP          --ETL处理时间戳
  FROM IOL.V_ICMS_ENT_INFO --视图-公司客户基本信息
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
  ETL_DBMS_STATS(V_P_DATE, 'O_IOL_ICMS_ENT_INFO', '', O_ERRCODE);

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

END ETL_O_IOL_ICMS_ENT_INFO;
/

