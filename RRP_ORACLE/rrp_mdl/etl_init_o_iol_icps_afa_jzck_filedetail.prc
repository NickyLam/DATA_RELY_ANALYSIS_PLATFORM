CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_IOL_ICPS_AFA_JZCK_FILEDETAIL(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_INIT_O_IOL_ICPS_AFA_JZCK_FILEDETAIL
  *  功能描述：文件明细表
  *  创建日期：20230302
  *  开发人员：梅炜
  *  来源表： IOL.V_ICPS_AFA_JZCK_FILEDETAIL
  *  目标表： O_IOL_ICPS_AFA_JZCK_FILEDETAIL
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220619  梅炜     首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_INIT_O_IOL_ICPS_AFA_JZCK_FILEDETAIL'; -- 程序名称
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
   -- EXECUTE IMMEDIATE ' TRUNCATE TABLE  O_IOL_ICPS_AFA_JZCK_FILEDETAIL' ;
  -- -- EXECUTE IMMEDIATE ' TRUNCATE TABLE O_IOL_ICPS_AFA_JZCK_FILEDETAIL';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-文件明细表';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IOL_ICPS_AFA_JZCK_FILEDETAIL
  (
					PRODUCTCODE  --产品代码详见产品代码数据字典
					,WORKDATE  --平台日期
					,AGENTSERIALNO  --平台流水号
					,WORKTIME  --平台时间
					,REQID  --请求单号
					,REQBATNO  --请求批次号
					,REQTYPE  --措施类别YH：商业银行,RH：人民银行
					,OPTTYPE  --请求类型:00-常规查询 10-动态查询 20-账户冻结 21-子户冻结 22-金额续冻 40-解冻 50-账户止付 51-子户止付 52-金额止付 60-止付延期 70-解止 80-凭证调阅 90-直接扣划 91-续冻扣划 92-解冻扣划
					,APPLYSEQ  --申请序号申请序号
					,APPLYTYPE  --申请控制类型根据该项拍判断资产的类型，1-存款，2-非存款类金融资产。（此判断项主要区别资产类型，目前分为存款和金融资产）
					,APPLYORGCODE  --申请机构代码
					,TARGETORGCODE  --目标机构代码
					,SUBJECTTYPE  --查控主体类别01代表查询个人主体；02代表查询对公（单位）主体；
					,CASETYPE  --案件类型:(法院：01冻结，02继续冻结，04解除冻结，06扣划)
					,CASENO  --执行案号
					,EMERGENCYLEVEL  --紧急程度01代表正常；02代表加急。
					,SENDTIME  --发送时间发送请求给目标机构时的系统日期时间，采用格式YYYYMMDDHHMMSS，24小时制格式，例如：20150410082210
					,TASKID  --任务流水号查询任务的流水号，唯一标识查询的任务；编码为：请求单标识+序号（00001-99999）；
					,ORIGTASKID  --原任务流水号原动态查询任务流水号识；措施类型为03和04时使用；
					,USERNAME  --姓名
					,IDTYPE  --证件类型
					,IDNO  --证件号码
					,ACCOUNTNO  --账卡号
					,ACCOUNTNUMBER  --账户序号冻结序号（子账号 ）
					,ACCOUNTTYPE  --账户类别
					,ACCOUNTOPENBANKNAME  --开户网点
					,ACCOUNTOPENBANKCODE  --开户网点代码人行统一的网点代码
					,CONTROLCONTENT  --控制类容根据该项判断控制内容,1-账户下的资金,2-账户（在先对控制类型判断结束后再针对控制内容进行判断）
					,TIMETYPE  --时段类型01表示开户至今；02表示当年数据；03自定义时间段；
					,STARTTIME  --起始时间
					,ENDTIME  --结束时间
					,FROZENTYPE  --冻结方式01-限额内冻结；02-只收不付
					,AMOUNT  --金额申请冻结限额
					,CURRENCY  --币种
					,FROZEDBALANCE  --执行冻结金额
					,ACCOUNTBALANCE  --账户余额
					,ACCOUNTAVAIABLEBALANCE  --账户可用余额
					,HOSTFREEZESERIAL  --核心日期
					,HOSTDATE  --核心日期
					,FORMERAPPLICATIONDEPARTMENT  --在先冻结机关
					,FORMERFROZENBALANCE  --在先冻结金额
					,FORMERFROZENEXPIRETIME  --在先冻结到期日
					,UNFROZEDBALANCE  --未冻结金额
					,EXECUNITNAME  --执行单位名称
					,EXECUNITNO  --执行单位代码
					,HANDLER  --承办人员姓名
					,TELEPHONE  --承办人员联系电话
					,HANDLERADDRESS  --承办人员联系地址
					,HANDLERIDTYPE  --承办人员证件类型
					,HANDLERIDNO  --承办人员证件号码
					,HANDLERWORKIDNO  --承办人员工作证编号
					,HANDLEROFFICEIDNO  --承办人员公务证编号
					,HELPER  --协查人姓名
					,HELPERTELEPHONE  --协查人联系电话
					,HELPERIDTYPE  --协查人证件类型
					,HELPERIDNO  --协查人证件号码
					,DOCUMENTNAME  --法律文书名称
					,DOCUMENTNO  --法律文书编号
					,ORIGCASENO  --原执行案号
					,ASSETSNAME  --金融资产名称KZLX=2时提供该项
					,ASSETSTYPE  --金融资产类型KZLX=2时提供该项
					,UNITS  --计量单位KZLX=2时提供该项
					,ISCHANGE  --是否结汇
					,EXECACCOUNTNAME  --执行款专户户名划扣存款时提供该项
					,EXECACCOUNTBANKNAME  --执行款专户开户行划扣存款时提供该项
					,EXECACCOUNTBANKCODE  --执行款专户开户行行号人行提供行号代码(供跨行划拨时提供)
					,EXECACCOUNT  --执行款专户账号划扣存款时提供该项
					,EXECACCOUNTTYPE  --执行款专户类型划扣存款时提供该项，如本币、外币
					,TRADEBUSISTEP  --业务处理步骤0-数据入库,1-平台处理,2-文件传输
					,TRADESTATUS  --业务处理状态0-失败,1-成功,2-未知,3-处理中
					,DEALCODE  --处理状态码 1-未处理 2-已处理
					,DEALMSG  --处理状态信息
					,REMARK  --备注
					,REMARK1  --备用1
					,REMARK2  --备用2
					,REMARK3  --备用3
					,TRADESYSTEM  --0-法院查控1-公安查控 2-监委查控 3-电信反欺诈
					,TRADETYPE  --请求类型:00-常规查询 10-动态查询 20-账户冻结 21-子户冻结 22-金额续冻 40-解冻 50-账户止付 51-子户止付 52-金额止付 60-止付延期 70-解止 80-凭证调阅
					,PROCEMODE  --处理方式
					,TELPHONE  --被核查人手机号
					,CXZL  --查询种类
					,APPLICATIONORGNAME  --申请机构名称
					,GLBL_SEQ_NO  --全局流水号
					,APPLICATIONTYPE  --是否补流程
					,FILEID  --????????
					,FORMERCCY  --在先冻结币种
					,TRANSSERIALNUMBER  --传输报文流水号
					,TRANSFERAMOUNT  --转出金额
					,TRANSFERTIME  --转出时间
					,APPLICATIONTIME  --申请时间
					,RESULT  --处理结果
					,WITHDRAWALTIME  --解除生效时间
					,TELLERNO  --柜员
					,BRNO  --机构
					,AUTHOR  --授权人
					,MANAGER  --金融机构主管
					,HELPERMOBILEPHONE  --协查人手机号
					,UPDDATE  --更新日期
					,UPDTIME  --更新时间
					,CKWH  --裁定书文号
					,CPXSZL  --产品销售种类
					,FEEDBACKORGNAME  --反馈机构名称
					,FKSJHM  --反馈手机号码
					,FEEDBACKREMARK  --反馈说明
					,BUSLICENSE  --工商营业执照
					,DQH  --国家/地区
					,HCLX  --核查类型
					,HCSXJE  --核查上限金额
					,THAWMODE  --解除方式
					,DELTELLERNO  --解除柜员
					,DELBRNO  --解除机构
					,JRCPBH  --金融产品编号
					,CARDNO  --卡号
					,KZZT  --控制结果
					,LCZH  --理财账号
					,PZTXLX  --凭证图像类型
					,PZTXMC  --凭证图像名称
					,REQUESTTXCODE  --请求交易类型编码
					,RESPONSETXCODE  --返回交易类型编码
					,QQRBGDH  --请求人办公电话
					,BUSISERNO  --业务流水号
					,THREEINONE  --三证合一号码
					,SE  --申请控制数量/份额/金额
					,SKSE  --实控数量/份额/金额
					,SFDYSXJE  --是否超过核查上限金额
					,SFXD  --是否修订
					,UNFROZEDTYPE  --系统解冻类型
					,XCRBGDH  --协查人办公电话
					,YDJAH  --原冻结案号
					,ZFFS  --止付处理方式
					,LOCATION  --注册地名称
					,TRANSFEROUTACCOUNTNUMBER  --转出帐卡号
					,TRANSFEROUTACCOUNTNAME  --转出账户名
					,TRANSFEROUTBANKID  --转出账户所属银行机构编码
					,TRANSFEROUTBANKNAME  --转出账户银行名称
					,ZJHKZH  --资金回款账户
					,ORGCODE  --组织机构代码
					,FROFLAG  --冻结标志
					,EXCHANGETYPE  --钞汇类型
					,QUERYCONTENT  --查询内容标识代码：01 账户信息；02 账户交易明细信息；03 账户和账户的交易明细信息；此处值默认为01；
					,FHBZ  --复核标志
					,FKLX  --反馈标志
					,ISFROZED  --是否已解冻:0-否；1-是
					,ORIGHELPERIDTYPE  --原始渠道协查人证件类型编码
					,ORIGHANDLERIDTYPE  --原始渠道承办人员证件类型编码
					,ORIGIDTYPE  --原始渠道证件类型编码
					,NEWACCOUNTNO  --换卡卡号（未换卡默认为空）
					,QUERYDATA  --查询内容
					,UPLOADFLAG  --是否已上传回执:1:已上传;0:未上传
					,BANKCODE  --开户行代码-默认:313586000006
					,BANKNAME  --开户行名称-默认:广东华兴银行股份有限公司
					,ISTRANSEE  --是否调取电子证据
					,PRTSENDFLAG  --外屏推送标识 0-初始录入;1-需要后续处理;2-不需要后续处理
					,ETL_DT  --ETL处理日期
					,ETL_TIMESTAMP  --ETL处理时间戳
    )
    SELECT
					PRODUCTCODE  --产品代码详见产品代码数据字典
					,WORKDATE  --平台日期
					,AGENTSERIALNO  --平台流水号
					,WORKTIME  --平台时间
					,REQID  --请求单号
					,REQBATNO  --请求批次号
					,REQTYPE  --措施类别YH：商业银行,RH：人民银行
					,OPTTYPE  --请求类型:00-常规查询 10-动态查询 20-账户冻结 21-子户冻结 22-金额续冻 40-解冻 50-账户止付 51-子户止付 52-金额止付 60-止付延期 70-解止 80-凭证调阅 90-直接扣划 91-续冻扣划 92-解冻扣划
					,APPLYSEQ  --申请序号申请序号
					,APPLYTYPE  --申请控制类型根据该项拍判断资产的类型，1-存款，2-非存款类金融资产。（此判断项主要区别资产类型，目前分为存款和金融资产）
					,APPLYORGCODE  --申请机构代码
					,TARGETORGCODE  --目标机构代码
					,SUBJECTTYPE  --查控主体类别01代表查询个人主体；02代表查询对公（单位）主体；
					,CASETYPE  --案件类型:(法院：01冻结，02继续冻结，04解除冻结，06扣划)
					,CASENO  --执行案号
					,EMERGENCYLEVEL  --紧急程度01代表正常；02代表加急。
					,SENDTIME  --发送时间发送请求给目标机构时的系统日期时间，采用格式YYYYMMDDHHMMSS，24小时制格式，例如：20150410082210
					,TASKID  --任务流水号查询任务的流水号，唯一标识查询的任务；编码为：请求单标识+序号（00001-99999）；
					,ORIGTASKID  --原任务流水号原动态查询任务流水号识；措施类型为03和04时使用；
					,USERNAME  --姓名
					,IDTYPE  --证件类型
					,IDNO  --证件号码
					,ACCOUNTNO  --账卡号
					,ACCOUNTNUMBER  --账户序号冻结序号（子账号 ）
					,ACCOUNTTYPE  --账户类别
					,ACCOUNTOPENBANKNAME  --开户网点
					,ACCOUNTOPENBANKCODE  --开户网点代码人行统一的网点代码
					,CONTROLCONTENT  --控制类容根据该项判断控制内容,1-账户下的资金,2-账户（在先对控制类型判断结束后再针对控制内容进行判断）
					,TIMETYPE  --时段类型01表示开户至今；02表示当年数据；03自定义时间段；
					,STARTTIME  --起始时间
					,ENDTIME  --结束时间
					,FROZENTYPE  --冻结方式01-限额内冻结；02-只收不付
					,AMOUNT  --金额申请冻结限额
					,CURRENCY  --币种
					,FROZEDBALANCE  --执行冻结金额
					,ACCOUNTBALANCE  --账户余额
					,ACCOUNTAVAIABLEBALANCE  --账户可用余额
					,HOSTFREEZESERIAL  --核心日期
					,HOSTDATE  --核心日期
					,FORMERAPPLICATIONDEPARTMENT  --在先冻结机关
					,FORMERFROZENBALANCE  --在先冻结金额
					,FORMERFROZENEXPIRETIME  --在先冻结到期日
					,UNFROZEDBALANCE  --未冻结金额
					,EXECUNITNAME  --执行单位名称
					,EXECUNITNO  --执行单位代码
					,HANDLER  --承办人员姓名
					,TELEPHONE  --承办人员联系电话
					,HANDLERADDRESS  --承办人员联系地址
					,HANDLERIDTYPE  --承办人员证件类型
					,HANDLERIDNO  --承办人员证件号码
					,HANDLERWORKIDNO  --承办人员工作证编号
					,HANDLEROFFICEIDNO  --承办人员公务证编号
					,HELPER  --协查人姓名
					,HELPERTELEPHONE  --协查人联系电话
					,HELPERIDTYPE  --协查人证件类型
					,HELPERIDNO  --协查人证件号码
					,DOCUMENTNAME  --法律文书名称
					,DOCUMENTNO  --法律文书编号
					,ORIGCASENO  --原执行案号
					,ASSETSNAME  --金融资产名称KZLX=2时提供该项
					,ASSETSTYPE  --金融资产类型KZLX=2时提供该项
					,UNITS  --计量单位KZLX=2时提供该项
					,ISCHANGE  --是否结汇
					,EXECACCOUNTNAME  --执行款专户户名划扣存款时提供该项
					,EXECACCOUNTBANKNAME  --执行款专户开户行划扣存款时提供该项
					,EXECACCOUNTBANKCODE  --执行款专户开户行行号人行提供行号代码(供跨行划拨时提供)
					,EXECACCOUNT  --执行款专户账号划扣存款时提供该项
					,EXECACCOUNTTYPE  --执行款专户类型划扣存款时提供该项，如本币、外币
					,TRADEBUSISTEP  --业务处理步骤0-数据入库,1-平台处理,2-文件传输
					,TRADESTATUS  --业务处理状态0-失败,1-成功,2-未知,3-处理中
					,DEALCODE  --处理状态码 1-未处理 2-已处理
					,DEALMSG  --处理状态信息
					,REMARK  --备注
					,REMARK1  --备用1
					,REMARK2  --备用2
					,REMARK3  --备用3
					,TRADESYSTEM  --0-法院查控1-公安查控 2-监委查控 3-电信反欺诈
					,TRADETYPE  --请求类型:00-常规查询 10-动态查询 20-账户冻结 21-子户冻结 22-金额续冻 40-解冻 50-账户止付 51-子户止付 52-金额止付 60-止付延期 70-解止 80-凭证调阅
					,PROCEMODE  --处理方式
					,TELPHONE  --被核查人手机号
					,CXZL  --查询种类
					,APPLICATIONORGNAME  --申请机构名称
					,GLBL_SEQ_NO  --全局流水号
					,APPLICATIONTYPE  --是否补流程
					,FILEID  --????????
					,FORMERCCY  --在先冻结币种
					,TRANSSERIALNUMBER  --传输报文流水号
					,TRANSFERAMOUNT  --转出金额
					,TRANSFERTIME  --转出时间
					,APPLICATIONTIME  --申请时间
					,RESULT  --处理结果
					,WITHDRAWALTIME  --解除生效时间
					,TELLERNO  --柜员
					,BRNO  --机构
					,AUTHOR  --授权人
					,MANAGER  --金融机构主管
					,HELPERMOBILEPHONE  --协查人手机号
					,UPDDATE  --更新日期
					,UPDTIME  --更新时间
					,CKWH  --裁定书文号
					,CPXSZL  --产品销售种类
					,FEEDBACKORGNAME  --反馈机构名称
					,FKSJHM  --反馈手机号码
					,FEEDBACKREMARK  --反馈说明
					,BUSLICENSE  --工商营业执照
					,DQH  --国家/地区
					,HCLX  --核查类型
					,HCSXJE  --核查上限金额
					,THAWMODE  --解除方式
					,DELTELLERNO  --解除柜员
					,DELBRNO  --解除机构
					,JRCPBH  --金融产品编号
					,CARDNO  --卡号
					,KZZT  --控制结果
					,LCZH  --理财账号
					,PZTXLX  --凭证图像类型
					,PZTXMC  --凭证图像名称
					,REQUESTTXCODE  --请求交易类型编码
					,RESPONSETXCODE  --返回交易类型编码
					,QQRBGDH  --请求人办公电话
					,BUSISERNO  --业务流水号
					,THREEINONE  --三证合一号码
					,SE  --申请控制数量/份额/金额
					,SKSE  --实控数量/份额/金额
					,SFDYSXJE  --是否超过核查上限金额
					,SFXD  --是否修订
					,UNFROZEDTYPE  --系统解冻类型
					,XCRBGDH  --协查人办公电话
					,YDJAH  --原冻结案号
					,ZFFS  --止付处理方式
					,LOCATION  --注册地名称
					,TRANSFEROUTACCOUNTNUMBER  --转出帐卡号
					,TRANSFEROUTACCOUNTNAME  --转出账户名
					,TRANSFEROUTBANKID  --转出账户所属银行机构编码
					,TRANSFEROUTBANKNAME  --转出账户银行名称
					,ZJHKZH  --资金回款账户
					,ORGCODE  --组织机构代码
					,FROFLAG  --冻结标志
					,EXCHANGETYPE  --钞汇类型
					,QUERYCONTENT  --查询内容标识代码：01 账户信息；02 账户交易明细信息；03 账户和账户的交易明细信息；此处值默认为01；
					,FHBZ  --复核标志
					,FKLX  --反馈标志
					,ISFROZED  --是否已解冻:0-否；1-是
					,ORIGHELPERIDTYPE  --原始渠道协查人证件类型编码
					,ORIGHANDLERIDTYPE  --原始渠道承办人员证件类型编码
					,ORIGIDTYPE  --原始渠道证件类型编码
					,NEWACCOUNTNO  --换卡卡号（未换卡默认为空）
					,QUERYDATA  --查询内容
					,UPLOADFLAG  --是否已上传回执:1:已上传;0:未上传
					,BANKCODE  --开户行代码-默认:313586000006
					,BANKNAME  --开户行名称-默认:广东华兴银行股份有限公司
					,ISTRANSEE  --是否调取电子证据
					,PRTSENDFLAG  --外屏推送标识 0-初始录入;1-需要后续处理;2-不需要后续处理
					,ETL_DT  --ETL处理日期
					,ETL_TIMESTAMP  --ETL处理时间戳
    FROM IOL.V_ICPS_AFA_JZCK_FILEDETAIL  --视图-文件明细表

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

  END ETL_INIT_O_IOL_ICPS_AFA_JZCK_FILEDETAIL;
/

