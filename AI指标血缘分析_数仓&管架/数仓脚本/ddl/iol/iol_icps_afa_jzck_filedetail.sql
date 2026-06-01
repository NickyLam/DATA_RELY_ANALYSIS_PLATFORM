/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icps_afa_jzck_filedetail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icps_afa_jzck_filedetail
whenever sqlerror continue none;
drop table ${iol_schema}.icps_afa_jzck_filedetail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icps_afa_jzck_filedetail(
    productcode varchar2(10) -- 产品代码详见产品代码数据字典
    ,workdate varchar2(8) -- 平台日期
    ,agentserialno varchar2(25) -- 平台流水号
    ,worktime varchar2(6) -- 平台时间
    ,reqid varchar2(53) -- 请求单号
    ,reqbatno varchar2(67) -- 请求批次号
    ,reqtype varchar2(10) -- 措施类别yh：商业银行,rh：人民银行
    ,opttype varchar2(2) -- 请求类型:00-常规查询 10-动态查询 20-账户冻结 21-子户冻结 22-金额续冻 40-解冻 50-账户止付 51-子户止付 52-金额止付 60-止付延期 70-解止 80-凭证调阅 90-直接扣划 91-续冻扣划 92-解冻扣划
    ,applyseq varchar2(10) -- 申请序号申请序号
    ,applytype varchar2(10) -- 申请控制类型根据该项拍判断资产的类型，1-存款，2-非存款类金融资产。（此判断项主要区别资产类型，目前分为存款和金融资产）
    ,applyorgcode varchar2(20) -- 申请机构代码
    ,targetorgcode varchar2(20) -- 目标机构代码
    ,subjecttype varchar2(10) -- 查控主体类别01代表查询个人主体；02代表查询对公（单位）主体；
    ,casetype varchar2(400) -- 案件类型:(法院：01冻结，02继续冻结，04解除冻结，06扣划)
    ,caseno varchar2(200) -- 执行案号
    ,emergencylevel varchar2(2) -- 紧急程度01代表正常；02代表加急。
    ,sendtime varchar2(20) -- 发送时间发送请求给目标机构时的系统日期时间，采用格式yyyymmddhhmmss，24小时制格式，例如：20150410082210
    ,taskid varchar2(200) -- 任务流水号查询任务的流水号，唯一标识查询的任务；编码为：请求单标识+序号（00001-99999）；
    ,origtaskid varchar2(50) -- 原任务流水号原动态查询任务流水号识；措施类型为03和04时使用；
    ,username varchar2(600) -- 姓名
    ,idtype varchar2(15) -- 证件类型
    ,idno varchar2(100) -- 证件号码
    ,accountno varchar2(80) -- 账卡号
    ,accountnumber varchar2(50) -- 账户序号冻结序号（子账号 ）
    ,accounttype varchar2(60) -- 账户类别
    ,accountopenbankname varchar2(200) -- 开户网点
    ,accountopenbankcode varchar2(40) -- 开户网点代码人行统一的网点代码
    ,controlcontent varchar2(2) -- 控制类容根据该项判断控制内容,1-账户下的资金,2-账户（在先对控制类型判断结束后再针对控制内容进行判断）
    ,timetype varchar2(2) -- 时段类型01表示开户至今；02表示当年数据；03自定义时间段；
    ,starttime varchar2(22) -- 起始时间
    ,endtime varchar2(20) -- 结束时间
    ,frozentype varchar2(10) -- 冻结方式01-限额内冻结；02-只收不付
    ,amount varchar2(20) -- 金额申请冻结限额
    ,currency varchar2(20) -- 币种
    ,frozedbalance varchar2(20) -- 执行冻结金额
    ,accountbalance varchar2(20) -- 账户余额
    ,accountavaiablebalance varchar2(20) -- 账户可用余额
    ,hostfreezeserial varchar2(40) -- 核心日期
    ,hostdate varchar2(14) -- 核心日期
    ,formerapplicationdepartment varchar2(2000) -- 在先冻结机关
    ,formerfrozenbalance varchar2(20) -- 在先冻结金额
    ,formerfrozenexpiretime varchar2(14) -- 在先冻结到期日
    ,unfrozedbalance varchar2(20) -- 未冻结金额
    ,execunitname varchar2(200) -- 执行单位名称
    ,execunitno varchar2(50) -- 执行单位代码
    ,handler varchar2(200) -- 承办人员姓名
    ,telephone varchar2(60) -- 承办人员联系电话
    ,handleraddress varchar2(400) -- 承办人员联系地址
    ,handleridtype varchar2(100) -- 承办人员证件类型
    ,handleridno varchar2(100) -- 承办人员证件号码
    ,handlerworkidno varchar2(160) -- 承办人员工作证编号
    ,handlerofficeidno varchar2(160) -- 承办人员公务证编号
    ,helper varchar2(200) -- 协查人姓名
    ,helpertelephone varchar2(60) -- 协查人联系电话
    ,helperidtype varchar2(100) -- 协查人证件类型
    ,helperidno varchar2(100) -- 协查人证件号码
    ,documentname varchar2(400) -- 法律文书名称
    ,documentno varchar2(200) -- 法律文书编号
    ,origcaseno varchar2(100) -- 原执行案号
    ,assetsname varchar2(80) -- 金融资产名称kzlx=2时提供该项
    ,assetstype varchar2(40) -- 金融资产类型kzlx=2时提供该项
    ,units varchar2(40) -- 计量单位kzlx=2时提供该项
    ,ischange varchar2(20) -- 是否结汇
    ,execaccountname varchar2(200) -- 执行款专户户名划扣存款时提供该项
    ,execaccountbankname varchar2(200) -- 执行款专户开户行划扣存款时提供该项
    ,execaccountbankcode varchar2(60) -- 执行款专户开户行行号人行提供行号代码(供跨行划拨时提供)
    ,execaccount varchar2(100) -- 执行款专户账号划扣存款时提供该项
    ,execaccounttype varchar2(120) -- 执行款专户类型划扣存款时提供该项，如本币、外币
    ,tradebusistep varchar2(2) -- 业务处理步骤0-数据入库,1-平台处理,2-文件传输
    ,tradestatus varchar2(2) -- 业务处理状态0-失败,1-成功,2-未知,3-处理中
    ,dealcode varchar2(15) -- 处理状态码 1-未处理 2-已处理
    ,dealmsg varchar2(1000) -- 处理状态信息
    ,remark varchar2(2000) -- 备注
    ,remark1 varchar2(800) -- 备用1
    ,remark2 varchar2(400) -- 备用2
    ,remark3 varchar2(400) -- 备用3
    ,tradesystem varchar2(1) -- 0-法院查控1-公安查控 2-监委查控 3-电信反欺诈
    ,tradetype varchar2(2) -- 请求类型:00-常规查询 10-动态查询 20-账户冻结 21-子户冻结 22-金额续冻 40-解冻 50-账户止付 51-子户止付 52-金额止付 60-止付延期 70-解止 80-凭证调阅
    ,procemode varchar2(1) -- 处理方式
    ,telphone varchar2(20) -- 被核查人手机号
    ,cxzl varchar2(3) -- 查询种类
    ,applicationorgname varchar2(400) -- 申请机构名称
    ,glbl_seq_no varchar2(100) -- 全局流水号
    ,applicationtype varchar2(10) -- 是否补流程
    ,fileid varchar2(2) -- ????????
    ,formerccy varchar2(20) -- 在先冻结币种
    ,transserialnumber varchar2(53) -- 传输报文流水号
    ,transferamount varchar2(20) -- 转出金额
    ,transfertime varchar2(14) -- 转出时间
    ,applicationtime varchar2(30) -- 申请时间
    ,result varchar2(4) -- 处理结果
    ,withdrawaltime varchar2(14) -- 解除生效时间
    ,tellerno varchar2(50) -- 柜员
    ,brno varchar2(50) -- 机构
    ,author varchar2(200) -- 授权人
    ,manager varchar2(200) -- 金融机构主管
    ,helpermobilephone varchar2(20) -- 协查人手机号
    ,upddate varchar2(8) -- 更新日期
    ,updtime varchar2(6) -- 更新时间
    ,ckwh varchar2(100) -- 裁定书文号
    ,cpxszl varchar2(20) -- 产品销售种类
    ,feedbackorgname varchar2(400) -- 反馈机构名称
    ,fksjhm varchar2(11) -- 反馈手机号码
    ,feedbackremark varchar2(400) -- 反馈说明
    ,buslicense varchar2(100) -- 工商营业执照
    ,dqh varchar2(200) -- 国家/地区
    ,hclx varchar2(8) -- 核查类型
    ,hcsxje varchar2(20) -- 核查上限金额
    ,thawmode varchar2(10) -- 解除方式
    ,deltellerno varchar2(50) -- 解除柜员
    ,delbrno varchar2(50) -- 解除机构
    ,jrcpbh varchar2(50) -- 金融产品编号
    ,cardno varchar2(50) -- 卡号
    ,kzzt varchar2(10) -- 控制结果
    ,lczh varchar2(50) -- 理财账号
    ,pztxlx varchar2(10) -- 凭证图像类型
    ,pztxmc varchar2(120) -- 凭证图像名称
    ,requesttxcode varchar2(10) -- 请求交易类型编码
    ,responsetxcode varchar2(10) -- 返回交易类型编码
    ,qqrbgdh varchar2(60) -- 请求人办公电话
    ,busiserno varchar2(100) -- 业务流水号
    ,threeinone varchar2(20) -- 三证合一号码
    ,se varchar2(20) -- 申请控制数量/份额/金额
    ,skse varchar2(20) -- 实控数量/份额/金额
    ,sfdysxje varchar2(10) -- 是否超过核查上限金额
    ,sfxd varchar2(2) -- 是否修订
    ,unfrozedtype varchar2(2) -- 系统解冻类型
    ,xcrbgdh varchar2(60) -- 协查人办公电话
    ,ydjah varchar2(100) -- 原冻结案号
    ,zffs varchar2(10) -- 止付处理方式
    ,location varchar2(400) -- 注册地名称
    ,transferoutaccountnumber varchar2(50) -- 转出帐卡号
    ,transferoutaccountname varchar2(360) -- 转出账户名
    ,transferoutbankid varchar2(12) -- 转出账户所属银行机构编码
    ,transferoutbankname varchar2(450) -- 转出账户银行名称
    ,zjhkzh varchar2(100) -- 资金回款账户
    ,orgcode varchar2(50) -- 组织机构代码
    ,froflag varchar2(10) -- 冻结标志
    ,exchangetype varchar2(20) -- 钞汇类型
    ,querycontent varchar2(2) -- 查询内容标识代码：01 账户信息；02 账户交易明细信息；03 账户和账户的交易明细信息；此处值默认为01；
    ,fhbz varchar2(1) -- 复核标志
    ,fklx varchar2(1) -- 反馈标志
    ,isfrozed varchar2(1) -- 是否已解冻:0-否；1-是
    ,orighelperidtype varchar2(100) -- 原始渠道协查人证件类型编码
    ,orighandleridtype varchar2(100) -- 原始渠道承办人员证件类型编码
    ,origidtype varchar2(100) -- 原始渠道证件类型编码
    ,newaccountno varchar2(40) -- 换卡卡号（未换卡默认为空）
    ,querydata varchar2(40) -- 查询内容
    ,uploadflag varchar2(1) -- 是否已上传回执:1:已上传;0:未上传
    ,bankcode varchar2(50) -- 开户行代码-默认:313586000006
    ,bankname varchar2(200) -- 开户行名称-默认:广东华兴银行股份有限公司
    ,istransee varchar2(1) -- 是否调取电子证据
    ,prtsendflag varchar2(2) -- 外屏推送标识 0-初始录入;1-需要后续处理;2-不需要后续处理
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.icps_afa_jzck_filedetail to ${iml_schema};
grant select on ${iol_schema}.icps_afa_jzck_filedetail to ${icl_schema};
grant select on ${iol_schema}.icps_afa_jzck_filedetail to ${idl_schema};
grant select on ${iol_schema}.icps_afa_jzck_filedetail to ${iel_schema};

-- comment
comment on table ${iol_schema}.icps_afa_jzck_filedetail is '文件明细表';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.productcode is '产品代码详见产品代码数据字典';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.workdate is '平台日期';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.agentserialno is '平台流水号';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.worktime is '平台时间';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.reqid is '请求单号';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.reqbatno is '请求批次号';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.reqtype is '措施类别yh：商业银行,rh：人民银行';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.opttype is '请求类型:00-常规查询 10-动态查询 20-账户冻结 21-子户冻结 22-金额续冻 40-解冻 50-账户止付 51-子户止付 52-金额止付 60-止付延期 70-解止 80-凭证调阅 90-直接扣划 91-续冻扣划 92-解冻扣划';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.applyseq is '申请序号申请序号';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.applytype is '申请控制类型根据该项拍判断资产的类型，1-存款，2-非存款类金融资产。（此判断项主要区别资产类型，目前分为存款和金融资产）';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.applyorgcode is '申请机构代码';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.targetorgcode is '目标机构代码';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.subjecttype is '查控主体类别01代表查询个人主体；02代表查询对公（单位）主体；';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.casetype is '案件类型:(法院：01冻结，02继续冻结，04解除冻结，06扣划)';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.caseno is '执行案号';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.emergencylevel is '紧急程度01代表正常；02代表加急。';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.sendtime is '发送时间发送请求给目标机构时的系统日期时间，采用格式yyyymmddhhmmss，24小时制格式，例如：20150410082210';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.taskid is '任务流水号查询任务的流水号，唯一标识查询的任务；编码为：请求单标识+序号（00001-99999）；';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.origtaskid is '原任务流水号原动态查询任务流水号识；措施类型为03和04时使用；';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.username is '姓名';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.idtype is '证件类型';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.idno is '证件号码';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.accountno is '账卡号';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.accountnumber is '账户序号冻结序号（子账号 ）';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.accounttype is '账户类别';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.accountopenbankname is '开户网点';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.accountopenbankcode is '开户网点代码人行统一的网点代码';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.controlcontent is '控制类容根据该项判断控制内容,1-账户下的资金,2-账户（在先对控制类型判断结束后再针对控制内容进行判断）';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.timetype is '时段类型01表示开户至今；02表示当年数据；03自定义时间段；';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.starttime is '起始时间';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.endtime is '结束时间';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.frozentype is '冻结方式01-限额内冻结；02-只收不付';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.amount is '金额申请冻结限额';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.currency is '币种';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.frozedbalance is '执行冻结金额';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.accountbalance is '账户余额';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.accountavaiablebalance is '账户可用余额';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.hostfreezeserial is '核心日期';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.hostdate is '核心日期';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.formerapplicationdepartment is '在先冻结机关';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.formerfrozenbalance is '在先冻结金额';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.formerfrozenexpiretime is '在先冻结到期日';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.unfrozedbalance is '未冻结金额';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.execunitname is '执行单位名称';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.execunitno is '执行单位代码';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.handler is '承办人员姓名';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.telephone is '承办人员联系电话';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.handleraddress is '承办人员联系地址';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.handleridtype is '承办人员证件类型';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.handleridno is '承办人员证件号码';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.handlerworkidno is '承办人员工作证编号';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.handlerofficeidno is '承办人员公务证编号';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.helper is '协查人姓名';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.helpertelephone is '协查人联系电话';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.helperidtype is '协查人证件类型';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.helperidno is '协查人证件号码';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.documentname is '法律文书名称';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.documentno is '法律文书编号';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.origcaseno is '原执行案号';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.assetsname is '金融资产名称kzlx=2时提供该项';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.assetstype is '金融资产类型kzlx=2时提供该项';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.units is '计量单位kzlx=2时提供该项';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.ischange is '是否结汇';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.execaccountname is '执行款专户户名划扣存款时提供该项';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.execaccountbankname is '执行款专户开户行划扣存款时提供该项';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.execaccountbankcode is '执行款专户开户行行号人行提供行号代码(供跨行划拨时提供)';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.execaccount is '执行款专户账号划扣存款时提供该项';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.execaccounttype is '执行款专户类型划扣存款时提供该项，如本币、外币';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.tradebusistep is '业务处理步骤0-数据入库,1-平台处理,2-文件传输';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.tradestatus is '业务处理状态0-失败,1-成功,2-未知,3-处理中';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.dealcode is '处理状态码 1-未处理 2-已处理';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.dealmsg is '处理状态信息';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.remark is '备注';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.remark1 is '备用1';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.remark2 is '备用2';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.remark3 is '备用3';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.tradesystem is '0-法院查控1-公安查控 2-监委查控 3-电信反欺诈';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.tradetype is '请求类型:00-常规查询 10-动态查询 20-账户冻结 21-子户冻结 22-金额续冻 40-解冻 50-账户止付 51-子户止付 52-金额止付 60-止付延期 70-解止 80-凭证调阅';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.procemode is '处理方式';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.telphone is '被核查人手机号';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.cxzl is '查询种类';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.applicationorgname is '申请机构名称';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.glbl_seq_no is '全局流水号';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.applicationtype is '是否补流程';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.fileid is '????????';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.formerccy is '在先冻结币种';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.transserialnumber is '传输报文流水号';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.transferamount is '转出金额';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.transfertime is '转出时间';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.applicationtime is '申请时间';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.result is '处理结果';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.withdrawaltime is '解除生效时间';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.tellerno is '柜员';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.brno is '机构';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.author is '授权人';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.manager is '金融机构主管';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.helpermobilephone is '协查人手机号';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.upddate is '更新日期';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.updtime is '更新时间';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.ckwh is '裁定书文号';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.cpxszl is '产品销售种类';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.feedbackorgname is '反馈机构名称';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.fksjhm is '反馈手机号码';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.feedbackremark is '反馈说明';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.buslicense is '工商营业执照';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.dqh is '国家/地区';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.hclx is '核查类型';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.hcsxje is '核查上限金额';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.thawmode is '解除方式';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.deltellerno is '解除柜员';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.delbrno is '解除机构';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.jrcpbh is '金融产品编号';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.cardno is '卡号';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.kzzt is '控制结果';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.lczh is '理财账号';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.pztxlx is '凭证图像类型';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.pztxmc is '凭证图像名称';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.requesttxcode is '请求交易类型编码';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.responsetxcode is '返回交易类型编码';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.qqrbgdh is '请求人办公电话';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.busiserno is '业务流水号';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.threeinone is '三证合一号码';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.se is '申请控制数量/份额/金额';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.skse is '实控数量/份额/金额';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.sfdysxje is '是否超过核查上限金额';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.sfxd is '是否修订';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.unfrozedtype is '系统解冻类型';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.xcrbgdh is '协查人办公电话';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.ydjah is '原冻结案号';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.zffs is '止付处理方式';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.location is '注册地名称';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.transferoutaccountnumber is '转出帐卡号';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.transferoutaccountname is '转出账户名';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.transferoutbankid is '转出账户所属银行机构编码';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.transferoutbankname is '转出账户银行名称';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.zjhkzh is '资金回款账户';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.orgcode is '组织机构代码';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.froflag is '冻结标志';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.exchangetype is '钞汇类型';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.querycontent is '查询内容标识代码：01 账户信息；02 账户交易明细信息；03 账户和账户的交易明细信息；此处值默认为01；';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.fhbz is '复核标志';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.fklx is '反馈标志';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.isfrozed is '是否已解冻:0-否；1-是';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.orighelperidtype is '原始渠道协查人证件类型编码';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.orighandleridtype is '原始渠道承办人员证件类型编码';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.origidtype is '原始渠道证件类型编码';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.newaccountno is '换卡卡号（未换卡默认为空）';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.querydata is '查询内容';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.uploadflag is '是否已上传回执:1:已上传;0:未上传';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.bankcode is '开户行代码-默认:313586000006';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.bankname is '开户行名称-默认:广东华兴银行股份有限公司';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.istransee is '是否调取电子证据';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.prtsendflag is '外屏推送标识 0-初始录入;1-需要后续处理;2-不需要后续处理';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icps_afa_jzck_filedetail.etl_timestamp is 'ETL处理时间戳';
