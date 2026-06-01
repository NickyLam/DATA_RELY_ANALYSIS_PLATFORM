/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icps_afa_jzck_filedetail
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icps_afa_jzck_filedetail_ex purge;
alter table ${iol_schema}.icps_afa_jzck_filedetail add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.icps_afa_jzck_filedetail truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.icps_afa_jzck_filedetail_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icps_afa_jzck_filedetail where 0=1;

insert /*+ append */ into ${iol_schema}.icps_afa_jzck_filedetail_ex(
    productcode -- 产品代码详见产品代码数据字典
    ,workdate -- 平台日期
    ,agentserialno -- 平台流水号
    ,worktime -- 平台时间
    ,reqid -- 请求单号
    ,reqbatno -- 请求批次号
    ,reqtype -- 措施类别YH：商业银行,RH：人民银行
    ,opttype -- 请求类型:00-常规查询 10-动态查询 20-账户冻结 21-子户冻结 22-金额续冻 40-解冻 50-账户止付 51-子户止付 52-金额止付 60-止付延期 70-解止 80-凭证调阅 90-直接扣划 91-续冻扣划 92-解冻扣划
    ,applyseq -- 申请序号申请序号
    ,applytype -- 申请控制类型根据该项拍判断资产的类型，1-存款，2-非存款类金融资产。（此判断项主要区别资产类型，目前分为存款和金融资产）
    ,applyorgcode -- 申请机构代码
    ,targetorgcode -- 目标机构代码
    ,subjecttype -- 查控主体类别01代表查询个人主体；02代表查询对公（单位）主体；
    ,casetype -- 案件类型:(法院：01冻结，02继续冻结，04解除冻结，06扣划)
    ,caseno -- 执行案号
    ,emergencylevel -- 紧急程度01代表正常；02代表加急。
    ,sendtime -- 发送时间发送请求给目标机构时的系统日期时间，采用格式YYYYMMDDhhmmss，24小时制格式，例如：20150410082210
    ,taskid -- 任务流水号查询任务的流水号，唯一标识查询的任务；编码为：请求单标识+序号（00001-99999）；
    ,origtaskid -- 原任务流水号原动态查询任务流水号识；措施类型为03和04时使用；
    ,username -- 姓名
    ,idtype -- 证件类型
    ,idno -- 证件号码
    ,accountno -- 账卡号
    ,accountnumber -- 账户序号冻结序号（子账号 ）
    ,accounttype -- 账户类别
    ,accountopenbankname -- 开户网点
    ,accountopenbankcode -- 开户网点代码人行统一的网点代码
    ,controlcontent -- 控制类容根据该项判断控制内容,1-账户下的资金,2-账户（在先对控制类型判断结束后再针对控制内容进行判断）
    ,timetype -- 时段类型01表示开户至今；02表示当年数据；03自定义时间段；
    ,starttime -- 起始时间
    ,endtime -- 结束时间
    ,frozentype -- 冻结方式01-限额内冻结；02-只收不付
    ,amount -- 金额申请冻结限额
    ,currency -- 币种
    ,frozedbalance -- 执行冻结金额
    ,accountbalance -- 账户余额
    ,accountavaiablebalance -- 账户可用余额
    ,hostfreezeserial -- 核心日期
    ,hostdate -- 核心日期
    ,formerapplicationdepartment -- 在先冻结机关
    ,formerfrozenbalance -- 在先冻结金额
    ,formerfrozenexpiretime -- 在先冻结到期日
    ,unfrozedbalance -- 未冻结金额
    ,execunitname -- 执行单位名称
    ,execunitno -- 执行单位代码
    ,handler -- 承办人员姓名
    ,telephone -- 承办人员联系电话
    ,handleraddress -- 承办人员联系地址
    ,handleridtype -- 承办人员证件类型
    ,handleridno -- 承办人员证件号码
    ,handlerworkidno -- 承办人员工作证编号
    ,handlerofficeidno -- 承办人员公务证编号
    ,helper -- 协查人姓名
    ,helpertelephone -- 协查人联系电话
    ,helperidtype -- 协查人证件类型
    ,helperidno -- 协查人证件号码
    ,documentname -- 法律文书名称
    ,documentno -- 法律文书编号
    ,origcaseno -- 原执行案号
    ,assetsname -- 金融资产名称KZLX=2时提供该项
    ,assetstype -- 金融资产类型KZLX=2时提供该项
    ,units -- 计量单位KZLX=2时提供该项
    ,ischange -- 是否结汇
    ,execaccountname -- 执行款专户户名划扣存款时提供该项
    ,execaccountbankname -- 执行款专户开户行划扣存款时提供该项
    ,execaccountbankcode -- 执行款专户开户行行号人行提供行号代码(供跨行划拨时提供)
    ,execaccount -- 执行款专户账号划扣存款时提供该项
    ,execaccounttype -- 执行款专户类型划扣存款时提供该项，如本币、外币
    ,tradebusistep -- 业务处理步骤0-数据入库,1-平台处理,2-文件传输
    ,tradestatus -- 业务处理状态0-失败,1-成功,2-未知,3-处理中
    ,dealcode -- 处理状态码 1-未处理 2-已处理
    ,dealmsg -- 处理状态信息
    ,remark -- 备注
    ,remark1 -- 备用1
    ,remark2 -- 备用2
    ,remark3 -- 备用3
    ,tradesystem -- 0-法院查控1-公安查控 2-监委查控 3-电信反欺诈
    ,tradetype -- 请求类型:00-常规查询 10-动态查询 20-账户冻结 21-子户冻结 22-金额续冻 40-解冻 50-账户止付 51-子户止付 52-金额止付 60-止付延期 70-解止 80-凭证调阅
    ,procemode -- 处理方式
    ,telphone -- 被核查人手机号
    ,cxzl -- 查询种类
    ,applicationorgname -- 申请机构名称
    ,glbl_seq_no -- 全局流水号
    ,applicationtype -- 是否补流程
    ,fileid -- ????????
    ,formerccy -- 在先冻结币种
    ,transserialnumber -- 传输报文流水号
    ,transferamount -- 转出金额
    ,transfertime -- 转出时间
    ,applicationtime -- 申请时间
    ,result -- 处理结果
    ,withdrawaltime -- 解除生效时间
    ,tellerno -- 柜员
    ,brno -- 机构
    ,author -- 授权人
    ,manager -- 金融机构主管
    ,helpermobilephone -- 协查人手机号
    ,upddate -- 更新日期
    ,updtime -- 更新时间
    ,ckwh -- 裁定书文号
    ,cpxszl -- 产品销售种类
    ,feedbackorgname -- 反馈机构名称
    ,fksjhm -- 反馈手机号码
    ,feedbackremark -- 反馈说明
    ,buslicense -- 工商营业执照
    ,dqh -- 国家/地区
    ,hclx -- 核查类型
    ,hcsxje -- 核查上限金额
    ,thawmode -- 解除方式
    ,deltellerno -- 解除柜员
    ,delbrno -- 解除机构
    ,jrcpbh -- 金融产品编号
    ,cardno -- 卡号
    ,kzzt -- 控制结果
    ,lczh -- 理财账号
    ,pztxlx -- 凭证图像类型
    ,pztxmc -- 凭证图像名称
    ,requesttxcode -- 请求交易类型编码
    ,responsetxcode -- 返回交易类型编码
    ,qqrbgdh -- 请求人办公电话
    ,busiserno -- 业务流水号
    ,threeinone -- 三证合一号码
    ,se -- 申请控制数量/份额/金额
    ,skse -- 实控数量/份额/金额
    ,sfdysxje -- 是否超过核查上限金额
    ,sfxd -- 是否修订
    ,unfrozedtype -- 系统解冻类型
    ,xcrbgdh -- 协查人办公电话
    ,ydjah -- 原冻结案号
    ,zffs -- 止付处理方式
    ,location -- 注册地名称
    ,transferoutaccountnumber -- 转出帐卡号
    ,transferoutaccountname -- 转出账户名
    ,transferoutbankid -- 转出账户所属银行机构编码
    ,transferoutbankname -- 转出账户银行名称
    ,zjhkzh -- 资金回款账户
    ,orgcode -- 组织机构代码
    ,froflag -- 冻结标志
    ,exchangetype -- 钞汇类型
    ,querycontent -- 查询内容标识代码：01 账户信息；02 账户交易明细信息；03 账户和账户的交易明细信息；此处值默认为01；
    ,fhbz -- 复核标志
    ,fklx -- 反馈标志
    ,isfrozed -- 是否已解冻:0-否；1-是
    ,orighelperidtype -- 原始渠道协查人证件类型编码
    ,orighandleridtype -- 原始渠道承办人员证件类型编码
    ,origidtype -- 原始渠道证件类型编码
    ,newaccountno -- 换卡卡号（未换卡默认为空）
    ,querydata -- 查询内容
    ,uploadflag -- 是否已上传回执:1:已上传;0:未上传
    ,bankcode -- 开户行代码-默认:313586000006
    ,bankname -- 开户行名称-默认:广东华兴银行股份有限公司
    ,istransee -- 是否调取电子证据
    ,prtsendflag -- 外屏推送标识 0-初始录入;1-需要后续处理;2-不需要后续处理
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    productcode -- 产品代码详见产品代码数据字典
    ,workdate -- 平台日期
    ,agentserialno -- 平台流水号
    ,worktime -- 平台时间
    ,reqid -- 请求单号
    ,reqbatno -- 请求批次号
    ,reqtype -- 措施类别YH：商业银行,RH：人民银行
    ,opttype -- 请求类型:00-常规查询 10-动态查询 20-账户冻结 21-子户冻结 22-金额续冻 40-解冻 50-账户止付 51-子户止付 52-金额止付 60-止付延期 70-解止 80-凭证调阅 90-直接扣划 91-续冻扣划 92-解冻扣划
    ,applyseq -- 申请序号申请序号
    ,applytype -- 申请控制类型根据该项拍判断资产的类型，1-存款，2-非存款类金融资产。（此判断项主要区别资产类型，目前分为存款和金融资产）
    ,applyorgcode -- 申请机构代码
    ,targetorgcode -- 目标机构代码
    ,subjecttype -- 查控主体类别01代表查询个人主体；02代表查询对公（单位）主体；
    ,casetype -- 案件类型:(法院：01冻结，02继续冻结，04解除冻结，06扣划)
    ,caseno -- 执行案号
    ,emergencylevel -- 紧急程度01代表正常；02代表加急。
    ,sendtime -- 发送时间发送请求给目标机构时的系统日期时间，采用格式YYYYMMDDhhmmss，24小时制格式，例如：20150410082210
    ,taskid -- 任务流水号查询任务的流水号，唯一标识查询的任务；编码为：请求单标识+序号（00001-99999）；
    ,origtaskid -- 原任务流水号原动态查询任务流水号识；措施类型为03和04时使用；
    ,username -- 姓名
    ,idtype -- 证件类型
    ,idno -- 证件号码
    ,accountno -- 账卡号
    ,accountnumber -- 账户序号冻结序号（子账号 ）
    ,accounttype -- 账户类别
    ,accountopenbankname -- 开户网点
    ,accountopenbankcode -- 开户网点代码人行统一的网点代码
    ,controlcontent -- 控制类容根据该项判断控制内容,1-账户下的资金,2-账户（在先对控制类型判断结束后再针对控制内容进行判断）
    ,timetype -- 时段类型01表示开户至今；02表示当年数据；03自定义时间段；
    ,starttime -- 起始时间
    ,endtime -- 结束时间
    ,frozentype -- 冻结方式01-限额内冻结；02-只收不付
    ,amount -- 金额申请冻结限额
    ,currency -- 币种
    ,frozedbalance -- 执行冻结金额
    ,accountbalance -- 账户余额
    ,accountavaiablebalance -- 账户可用余额
    ,hostfreezeserial -- 核心日期
    ,hostdate -- 核心日期
    ,formerapplicationdepartment -- 在先冻结机关
    ,formerfrozenbalance -- 在先冻结金额
    ,formerfrozenexpiretime -- 在先冻结到期日
    ,unfrozedbalance -- 未冻结金额
    ,execunitname -- 执行单位名称
    ,execunitno -- 执行单位代码
    ,handler -- 承办人员姓名
    ,telephone -- 承办人员联系电话
    ,handleraddress -- 承办人员联系地址
    ,handleridtype -- 承办人员证件类型
    ,handleridno -- 承办人员证件号码
    ,handlerworkidno -- 承办人员工作证编号
    ,handlerofficeidno -- 承办人员公务证编号
    ,helper -- 协查人姓名
    ,helpertelephone -- 协查人联系电话
    ,helperidtype -- 协查人证件类型
    ,helperidno -- 协查人证件号码
    ,documentname -- 法律文书名称
    ,documentno -- 法律文书编号
    ,origcaseno -- 原执行案号
    ,assetsname -- 金融资产名称KZLX=2时提供该项
    ,assetstype -- 金融资产类型KZLX=2时提供该项
    ,units -- 计量单位KZLX=2时提供该项
    ,ischange -- 是否结汇
    ,execaccountname -- 执行款专户户名划扣存款时提供该项
    ,execaccountbankname -- 执行款专户开户行划扣存款时提供该项
    ,execaccountbankcode -- 执行款专户开户行行号人行提供行号代码(供跨行划拨时提供)
    ,execaccount -- 执行款专户账号划扣存款时提供该项
    ,execaccounttype -- 执行款专户类型划扣存款时提供该项，如本币、外币
    ,tradebusistep -- 业务处理步骤0-数据入库,1-平台处理,2-文件传输
    ,tradestatus -- 业务处理状态0-失败,1-成功,2-未知,3-处理中
    ,dealcode -- 处理状态码 1-未处理 2-已处理
    ,dealmsg -- 处理状态信息
    ,remark -- 备注
    ,remark1 -- 备用1
    ,remark2 -- 备用2
    ,remark3 -- 备用3
    ,tradesystem -- 0-法院查控1-公安查控 2-监委查控 3-电信反欺诈
    ,tradetype -- 请求类型:00-常规查询 10-动态查询 20-账户冻结 21-子户冻结 22-金额续冻 40-解冻 50-账户止付 51-子户止付 52-金额止付 60-止付延期 70-解止 80-凭证调阅
    ,procemode -- 处理方式
    ,telphone -- 被核查人手机号
    ,cxzl -- 查询种类
    ,applicationorgname -- 申请机构名称
    ,glbl_seq_no -- 全局流水号
    ,applicationtype -- 是否补流程
    ,fileid -- ????????
    ,formerccy -- 在先冻结币种
    ,transserialnumber -- 传输报文流水号
    ,transferamount -- 转出金额
    ,transfertime -- 转出时间
    ,applicationtime -- 申请时间
    ,result -- 处理结果
    ,withdrawaltime -- 解除生效时间
    ,tellerno -- 柜员
    ,brno -- 机构
    ,author -- 授权人
    ,manager -- 金融机构主管
    ,helpermobilephone -- 协查人手机号
    ,upddate -- 更新日期
    ,updtime -- 更新时间
    ,ckwh -- 裁定书文号
    ,cpxszl -- 产品销售种类
    ,feedbackorgname -- 反馈机构名称
    ,fksjhm -- 反馈手机号码
    ,feedbackremark -- 反馈说明
    ,buslicense -- 工商营业执照
    ,dqh -- 国家/地区
    ,hclx -- 核查类型
    ,hcsxje -- 核查上限金额
    ,thawmode -- 解除方式
    ,deltellerno -- 解除柜员
    ,delbrno -- 解除机构
    ,jrcpbh -- 金融产品编号
    ,cardno -- 卡号
    ,kzzt -- 控制结果
    ,lczh -- 理财账号
    ,pztxlx -- 凭证图像类型
    ,pztxmc -- 凭证图像名称
    ,requesttxcode -- 请求交易类型编码
    ,responsetxcode -- 返回交易类型编码
    ,qqrbgdh -- 请求人办公电话
    ,busiserno -- 业务流水号
    ,threeinone -- 三证合一号码
    ,se -- 申请控制数量/份额/金额
    ,skse -- 实控数量/份额/金额
    ,sfdysxje -- 是否超过核查上限金额
    ,sfxd -- 是否修订
    ,unfrozedtype -- 系统解冻类型
    ,xcrbgdh -- 协查人办公电话
    ,ydjah -- 原冻结案号
    ,zffs -- 止付处理方式
    ,location -- 注册地名称
    ,transferoutaccountnumber -- 转出帐卡号
    ,transferoutaccountname -- 转出账户名
    ,transferoutbankid -- 转出账户所属银行机构编码
    ,transferoutbankname -- 转出账户银行名称
    ,zjhkzh -- 资金回款账户
    ,orgcode -- 组织机构代码
    ,froflag -- 冻结标志
    ,exchangetype -- 钞汇类型
    ,querycontent -- 查询内容标识代码：01 账户信息；02 账户交易明细信息；03 账户和账户的交易明细信息；此处值默认为01；
    ,fhbz -- 复核标志
    ,fklx -- 反馈标志
    ,isfrozed -- 是否已解冻:0-否；1-是
    ,orighelperidtype -- 原始渠道协查人证件类型编码
    ,orighandleridtype -- 原始渠道承办人员证件类型编码
    ,origidtype -- 原始渠道证件类型编码
    ,newaccountno -- 换卡卡号（未换卡默认为空）
    ,querydata -- 查询内容
    ,uploadflag -- 是否已上传回执:1:已上传;0:未上传
    ,bankcode -- 开户行代码-默认:313586000006
    ,bankname -- 开户行名称-默认:广东华兴银行股份有限公司
    ,istransee -- 是否调取电子证据
    ,prtsendflag -- 外屏推送标识 0-初始录入;1-需要后续处理;2-不需要后续处理
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.icps_afa_jzck_filedetail
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.icps_afa_jzck_filedetail exchange partition p_${batch_date} with table ${iol_schema}.icps_afa_jzck_filedetail_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icps_afa_jzck_filedetail to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.icps_afa_jzck_filedetail_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icps_afa_jzck_filedetail',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);