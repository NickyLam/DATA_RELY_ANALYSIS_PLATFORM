/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_aml_icps_afa_jzck_filedetail
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 4;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.aml_icps_afa_jzck_filedetail drop partition p_${last_date};
alter table ${idl_schema}.aml_icps_afa_jzck_filedetail drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.aml_icps_afa_jzck_filedetail add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.aml_icps_afa_jzck_filedetail (
    etl_dt  -- 数据日期
    ,productcode  -- 产品代码详见产品代码数据字典
    ,workdate  -- 平台日期
    ,agentserialno  -- 平台流水号
    ,worktime  -- 平台时间
    ,reqid  -- 请求单号
    ,reqbatno  -- 请求批次号
    ,reqtype  -- 措施类别YH：商业银行,RH：人民银行
    ,opttype  -- 请求类型:00-常规查询 10-动态查询 20-账户冻结 21-子户冻结 22-金额续冻 40-解冻 50-账户止付 51-子户止付 52-金额止付 60-止付延期 70-解止 80-凭证调阅 90-直接扣划 91-续冻扣划 92-解冻扣划
    ,applyseq  -- 申请序号申请序号
    ,applytype  -- 申请控制类型根据该项拍判断资产的类型，1-存款，2-非存款类金融资产。（此判断项主要区别资产类型，目前分为存款和金融资产）
    ,applyorgcode  -- 申请机构代码
    ,targetorgcode  -- 目标机构代码
    ,subjecttype  -- 查控主体类别01代表查询个人主体；02代表查询对公（单位）主体；
    ,casetype  -- 案件类型:(法院：01冻结，02继续冻结，04解除冻结，06扣划)
    ,caseno  -- 执行案号
    ,emergencylevel  -- 紧急程度01代表正常；02代表加急。
    ,sendtime  -- 发送时间发送请求给目标机构时的系统日期时间，采用格式YYYYMMDDhhmmss，24小时制格式，例如：20150410082210
    ,taskid  -- 任务流水号查询任务的流水号，唯一标识查询的任务；编码为：请求单标识+序号（00001-99999）；
    ,origtaskid  -- 原任务流水号原动态查询任务流水号识；措施类型为03和04时使用；
    ,username  -- 姓名
    ,idtype  -- 证件类型
    ,idno  -- 证件号码
    ,accountno  -- 账卡号
    ,accountnumber  -- 账户序号冻结序号（子账号 ）
    ,accounttype  -- 账户类别
    ,accountopenbankname  -- 开户网点
    ,accountopenbankcode  -- 开户网点代码人行统一的网点代码
    ,controlcontent  -- 控制类容根据该项判断控制内容,1-账户下的资金,2-账户（在先对控制类型判断结束后再针对控制内容进行判断）
    ,timetype  -- 时段类型01表示开户至今；02表示当年数据；03自定义时间段；
    ,starttime  -- 起始时间
    ,endtime  -- 结束时间
    ,frozentype  -- 冻结方式01-限额内冻结；02-只收不付
    ,amount  -- 金额申请冻结限额
    ,currency  -- 币种
    ,frozedbalance  -- 执行冻结金额
    ,accountbalance  -- 账户余额
    ,accountavaiablebalance  -- 账户可用余额
    ,hostfreezeserial  -- 核心日期
    ,hostdate  -- 核心日期
    ,formerapplicationdepartment  -- 在先冻结机关
    ,formerfrozenbalance  -- 在先冻结金额
    ,formerfrozenexpiretime  -- 在先冻结到期日
    ,unfrozedbalance  -- 未冻结金额
    ,execunitname  -- 执行单位名称
    ,execunitno  -- 执行单位代码
    ,handler  -- 承办人员姓名
    ,telephone  -- 承办人员联系电话
    ,handleraddress  -- 承办人员联系地址
    ,handleridtype  -- 承办人员证件类型
    ,handleridno  -- 承办人员证件号码
    ,handlerworkidno  -- 承办人员工作证编号
    ,handlerofficeidno  -- 承办人员公务证编号
    ,helper  -- 协查人姓名
    ,helpertelephone  -- 协查人联系电话
    ,helperidtype  -- 协查人证件类型
    ,helperidno  -- 协查人证件号码
    ,documentname  -- 法律文书名称
    ,documentno  -- 法律文书编号
    ,origcaseno  -- 原执行案号
    ,assetsname  -- 金融资产名称KZLX=2时提供该项
    ,assetstype  -- 金融资产类型KZLX=2时提供该项
    ,units  -- 计量单位KZLX=2时提供该项
    ,ischange  -- 是否结汇
    ,execaccountname  -- 执行款专户户名划扣存款时提供该项
    ,execaccountbankname  -- 执行款专户开户行划扣存款时提供该项
    ,execaccountbankcode  -- 执行款专户开户行行号人行提供行号代码(供跨行划拨时提供)
    ,execaccount  -- 执行款专户账号划扣存款时提供该项
    ,execaccounttype  -- 执行款专户类型划扣存款时提供该项，如本币、外币
    ,tradebusistep  -- 业务处理步骤0-数据入库,1-平台处理,2-文件传输
    ,tradestatus  -- 业务处理状态0-失败,1-成功,2-未知,3-处理中
    ,dealcode  -- 处理状态码 1-未处理 2-已处理
    ,dealmsg  -- 处理状态信息
    ,remark  -- 备注
    ,remark1  -- 备用1
    ,remark2  -- 备用2
    ,remark3  -- 备用3
    ,tradesystem  -- 0-法院查控1-公安查控 2-监委查控 3-电信反欺诈
    ,tradetype  -- 请求类型:00-常规查询 10-动态查询 20-账户冻结 21-子户冻结 22-金额续冻 40-解冻 50-账户止付 51-子户止付 52-金额止付 60-止付延期 70-解止 80-凭证调阅
    ,procemode  -- 处理方式
    ,telphone  -- 被核查人手机号
    ,cxzl  -- 查询种类
    ,applicationorgname  -- 申请机构名称
    ,glbl_seq_no  -- 全局流水号
    ,applicationtype  -- 是否补流程
    ,fileid  -- ????????
    ,formerccy  -- 在先冻结币种
    ,transserialnumber  -- 传输报文流水号
    ,transferamount  -- 转出金额
    ,transfertime  -- 转出时间
    ,applicationtime  -- 申请时间
    ,result  -- 处理结果
    ,withdrawaltime  -- 解除生效时间
    ,tellerno  -- 柜员
    ,brno  -- 机构
    ,author  -- 授权人
    ,manager  -- 金融机构主管
    ,helpermobilephone  -- 协查人手机号
    ,upddate  -- 更新日期
    ,updtime  -- 更新时间
    ,ckwh  -- 裁定书文号
    ,cpxszl  -- 产品销售种类
    ,feedbackorgname  -- 反馈机构名称
    ,fksjhm  -- 反馈手机号码
    ,feedbackremark  -- 反馈说明
    ,buslicense  -- 工商营业执照
    ,dqh  -- 国家/地区
    ,hclx  -- 核查类型
    ,hcsxje  -- 核查上限金额
    ,thawmode  -- 解除方式
    ,deltellerno  -- 解除柜员
    ,delbrno  -- 解除机构
    ,jrcpbh  -- 金融产品编号
    ,cardno  -- 卡号
    ,kzzt  -- 控制结果
    ,lczh  -- 理财账号
    ,pztxlx  -- 凭证图像类型
    ,pztxmc  -- 凭证图像名称
    ,requesttxcode  -- 请求交易类型编码
    ,responsetxcode  -- 返回交易类型编码
    ,qqrbgdh  -- 请求人办公电话
    ,busiserno  -- 业务流水号
    ,threeinone  -- 三证合一号码
    ,se  -- 申请控制数量/份额/金额
    ,skse  -- 实控数量/份额/金额
    ,sfdysxje  -- 是否超过核查上限金额
    ,sfxd  -- 是否修订
    ,unfrozedtype  -- 系统解冻类型
    ,xcrbgdh  -- 协查人办公电话
    ,ydjah  -- 原冻结案号
    ,zffs  -- 止付处理方式
    ,location  -- 注册地名称
    ,transferoutaccountnumber  -- 转出帐卡号
    ,transferoutaccountname  -- 转出账户名
    ,transferoutbankid  -- 转出账户所属银行机构编码
    ,transferoutbankname  -- 转出账户银行名称
    ,zjhkzh  -- 资金回款账户
    ,orgcode  -- 组织机构代码
    ,froflag  -- 冻结标志
    ,exchangetype  -- 钞汇类型
    ,querycontent  -- 查询内容标识代码：01 账户信息；02 账户交易明细信息；03 账户和账户的交易明细信息；此处值默认为01；
    ,fhbz  -- 复核标志
    ,fklx  -- 反馈标志
    ,isfrozed  -- 是否已解冻:0-否；1-是
    ,start_dt  -- 开始日期
    ,end_dt  -- 结束日期
    ,id_mark  -- 删除标识
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.productcode,chr(13),''),chr(10),'')  -- 产品代码详见产品代码数据字典
    ,replace(replace(t1.workdate,chr(13),''),chr(10),'')  -- 平台日期
    ,replace(replace(t1.agentserialno,chr(13),''),chr(10),'')  -- 平台流水号
    ,replace(replace(t1.worktime,chr(13),''),chr(10),'')  -- 平台时间
    ,replace(replace(t1.reqid,chr(13),''),chr(10),'')  -- 请求单号
    ,replace(replace(t1.reqbatno,chr(13),''),chr(10),'')  -- 请求批次号
    ,replace(replace(t1.reqtype,chr(13),''),chr(10),'')  -- 措施类别YH：商业银行,RH：人民银行
    ,replace(replace(t1.opttype,chr(13),''),chr(10),'')  -- 请求类型:00-常规查询 10-动态查询 20-账户冻结 21-子户冻结 22-金额续冻 40-解冻 50-账户止付 51-子户止付 52-金额止付 60-止付延期 70-解止 80-凭证调阅 90-直接扣划 91-续冻扣划 92-解冻扣划
    ,replace(replace(t1.applyseq,chr(13),''),chr(10),'')  -- 申请序号申请序号
    ,replace(replace(t1.applytype,chr(13),''),chr(10),'')  -- 申请控制类型根据该项拍判断资产的类型，1-存款，2-非存款类金融资产。（此判断项主要区别资产类型，目前分为存款和金融资产）
    ,replace(replace(t1.applyorgcode,chr(13),''),chr(10),'')  -- 申请机构代码
    ,replace(replace(t1.targetorgcode,chr(13),''),chr(10),'')  -- 目标机构代码
    ,replace(replace(t1.subjecttype,chr(13),''),chr(10),'')  -- 查控主体类别01代表查询个人主体；02代表查询对公（单位）主体；
    ,replace(replace(t1.casetype,chr(13),''),chr(10),'')  -- 案件类型:(法院：01冻结，02继续冻结，04解除冻结，06扣划)
    ,replace(replace(t1.caseno,chr(13),''),chr(10),'')  -- 执行案号
    ,replace(replace(t1.emergencylevel,chr(13),''),chr(10),'')  -- 紧急程度01代表正常；02代表加急。
    ,replace(replace(t1.sendtime,chr(13),''),chr(10),'')  -- 发送时间发送请求给目标机构时的系统日期时间，采用格式YYYYMMDDhhmmss，24小时制格式，例如：20150410082210
    ,replace(replace(t1.taskid,chr(13),''),chr(10),'')  -- 任务流水号查询任务的流水号，唯一标识查询的任务；编码为：请求单标识+序号（00001-99999）；
    ,replace(replace(t1.origtaskid,chr(13),''),chr(10),'')  -- 原任务流水号原动态查询任务流水号识；措施类型为03和04时使用；
    ,replace(replace(t1.username,chr(13),''),chr(10),'')  -- 姓名
    ,replace(replace(t1.idtype,chr(13),''),chr(10),'')  -- 证件类型
    ,replace(replace(t1.idno,chr(13),''),chr(10),'')  -- 证件号码
    ,replace(replace(t1.accountno,chr(13),''),chr(10),'')  -- 账卡号
    ,replace(replace(t1.accountnumber,chr(13),''),chr(10),'')  -- 账户序号冻结序号（子账号 ）
    ,replace(replace(t1.accounttype,chr(13),''),chr(10),'')  -- 账户类别
    ,replace(replace(t1.accountopenbankname,chr(13),''),chr(10),'')  -- 开户网点
    ,replace(replace(t1.accountopenbankcode,chr(13),''),chr(10),'')  -- 开户网点代码人行统一的网点代码
    ,replace(replace(t1.controlcontent,chr(13),''),chr(10),'')  -- 控制类容根据该项判断控制内容,1-账户下的资金,2-账户（在先对控制类型判断结束后再针对控制内容进行判断）
    ,replace(replace(t1.timetype,chr(13),''),chr(10),'')  -- 时段类型01表示开户至今；02表示当年数据；03自定义时间段；
    ,replace(replace(t1.starttime,chr(13),''),chr(10),'')  -- 起始时间
    ,replace(replace(t1.endtime,chr(13),''),chr(10),'')  -- 结束时间
    ,replace(replace(t1.frozentype,chr(13),''),chr(10),'')  -- 冻结方式01-限额内冻结；02-只收不付
    ,replace(replace(t1.amount,chr(13),''),chr(10),'')  -- 金额申请冻结限额
    ,replace(replace(t1.currency,chr(13),''),chr(10),'')  -- 币种
    ,replace(replace(t1.frozedbalance,chr(13),''),chr(10),'')  -- 执行冻结金额
    ,replace(replace(t1.accountbalance,chr(13),''),chr(10),'')  -- 账户余额
    ,replace(replace(t1.accountavaiablebalance,chr(13),''),chr(10),'')  -- 账户可用余额
    ,replace(replace(t1.hostfreezeserial,chr(13),''),chr(10),'')  -- 核心日期
    ,replace(replace(t1.hostdate,chr(13),''),chr(10),'')  -- 核心日期
    ,replace(replace(t1.formerapplicationdepartment,chr(13),''),chr(10),'')  -- 在先冻结机关
    ,replace(replace(t1.formerfrozenbalance,chr(13),''),chr(10),'')  -- 在先冻结金额
    ,replace(replace(t1.formerfrozenexpiretime,chr(13),''),chr(10),'')  -- 在先冻结到期日
    ,replace(replace(t1.unfrozedbalance,chr(13),''),chr(10),'')  -- 未冻结金额
    ,replace(replace(t1.execunitname,chr(13),''),chr(10),'')  -- 执行单位名称
    ,replace(replace(t1.execunitno,chr(13),''),chr(10),'')  -- 执行单位代码
    ,replace(replace(t1.handler,chr(13),''),chr(10),'')  -- 承办人员姓名
    ,replace(replace(t1.telephone,chr(13),''),chr(10),'')  -- 承办人员联系电话
    ,replace(replace(t1.handleraddress,chr(13),''),chr(10),'')  -- 承办人员联系地址
    ,replace(replace(t1.handleridtype,chr(13),''),chr(10),'')  -- 承办人员证件类型
    ,replace(replace(t1.handleridno,chr(13),''),chr(10),'')  -- 承办人员证件号码
    ,replace(replace(t1.handlerworkidno,chr(13),''),chr(10),'')  -- 承办人员工作证编号
    ,replace(replace(t1.handlerofficeidno,chr(13),''),chr(10),'')  -- 承办人员公务证编号
    ,replace(replace(t1.helper,chr(13),''),chr(10),'')  -- 协查人姓名
    ,replace(replace(t1.helpertelephone,chr(13),''),chr(10),'')  -- 协查人联系电话
    ,replace(replace(t1.helperidtype,chr(13),''),chr(10),'')  -- 协查人证件类型
    ,replace(replace(t1.helperidno,chr(13),''),chr(10),'')  -- 协查人证件号码
    ,replace(replace(t1.documentname,chr(13),''),chr(10),'')  -- 法律文书名称
    ,replace(replace(t1.documentno,chr(13),''),chr(10),'')  -- 法律文书编号
    ,replace(replace(t1.origcaseno,chr(13),''),chr(10),'')  -- 原执行案号
    ,replace(replace(t1.assetsname,chr(13),''),chr(10),'')  -- 金融资产名称KZLX=2时提供该项
    ,replace(replace(t1.assetstype,chr(13),''),chr(10),'')  -- 金融资产类型KZLX=2时提供该项
    ,replace(replace(t1.units,chr(13),''),chr(10),'')  -- 计量单位KZLX=2时提供该项
    ,replace(replace(t1.ischange,chr(13),''),chr(10),'')  -- 是否结汇
    ,replace(replace(t1.execaccountname,chr(13),''),chr(10),'')  -- 执行款专户户名划扣存款时提供该项
    ,replace(replace(t1.execaccountbankname,chr(13),''),chr(10),'')  -- 执行款专户开户行划扣存款时提供该项
    ,replace(replace(t1.execaccountbankcode,chr(13),''),chr(10),'')  -- 执行款专户开户行行号人行提供行号代码(供跨行划拨时提供)
    ,replace(replace(t1.execaccount,chr(13),''),chr(10),'')  -- 执行款专户账号划扣存款时提供该项
    ,replace(replace(t1.execaccounttype,chr(13),''),chr(10),'')  -- 执行款专户类型划扣存款时提供该项，如本币、外币
    ,replace(replace(t1.tradebusistep,chr(13),''),chr(10),'')  -- 业务处理步骤0-数据入库,1-平台处理,2-文件传输
    ,replace(replace(t1.tradestatus,chr(13),''),chr(10),'')  -- 业务处理状态0-失败,1-成功,2-未知,3-处理中
    ,replace(replace(t1.dealcode,chr(13),''),chr(10),'')  -- 处理状态码 1-未处理 2-已处理
    ,replace(replace(t1.dealmsg,chr(13),''),chr(10),'')  -- 处理状态信息
    ,replace(replace(t1.remark,chr(13),''),chr(10),'')  -- 备注
    ,replace(replace(t1.remark1,chr(13),''),chr(10),'')  -- 备用1
    ,replace(replace(t1.remark2,chr(13),''),chr(10),'')  -- 备用2
    ,replace(replace(t1.remark3,chr(13),''),chr(10),'')  -- 备用3
    ,replace(replace(t1.tradesystem,chr(13),''),chr(10),'')  -- 0-法院查控1-公安查控 2-监委查控 3-电信反欺诈
    ,replace(replace(t1.tradetype,chr(13),''),chr(10),'')  -- 请求类型:00-常规查询 10-动态查询 20-账户冻结 21-子户冻结 22-金额续冻 40-解冻 50-账户止付 51-子户止付 52-金额止付 60-止付延期 70-解止 80-凭证调阅
    ,replace(replace(t1.procemode,chr(13),''),chr(10),'')  -- 处理方式
    ,replace(replace(t1.telphone,chr(13),''),chr(10),'')  -- 被核查人手机号
    ,replace(replace(t1.cxzl,chr(13),''),chr(10),'')  -- 查询种类
    ,replace(replace(t1.applicationorgname,chr(13),''),chr(10),'')  -- 申请机构名称
    ,replace(replace(t1.glbl_seq_no,chr(13),''),chr(10),'')  -- 全局流水号
    ,replace(replace(t1.applicationtype,chr(13),''),chr(10),'')  -- 是否补流程
    ,replace(replace(t1.fileid,chr(13),''),chr(10),'')  -- ????????
    ,replace(replace(t1.formerccy,chr(13),''),chr(10),'')  -- 在先冻结币种
    ,replace(replace(t1.transserialnumber,chr(13),''),chr(10),'')  -- 传输报文流水号
    ,replace(replace(t1.transferamount,chr(13),''),chr(10),'')  -- 转出金额
    ,replace(replace(t1.transfertime,chr(13),''),chr(10),'')  -- 转出时间
    ,replace(replace(t1.applicationtime,chr(13),''),chr(10),'')  -- 申请时间
    ,replace(replace(t1.result,chr(13),''),chr(10),'')  -- 处理结果
    ,replace(replace(t1.withdrawaltime,chr(13),''),chr(10),'')  -- 解除生效时间
    ,replace(replace(t1.tellerno,chr(13),''),chr(10),'')  -- 柜员
    ,replace(replace(t1.brno,chr(13),''),chr(10),'')  -- 机构
    ,replace(replace(t1.author,chr(13),''),chr(10),'')  -- 授权人
    ,replace(replace(t1.manager,chr(13),''),chr(10),'')  -- 金融机构主管
    ,replace(replace(t1.helpermobilephone,chr(13),''),chr(10),'')  -- 协查人手机号
    ,replace(replace(t1.upddate,chr(13),''),chr(10),'')  -- 更新日期
    ,replace(replace(t1.updtime,chr(13),''),chr(10),'')  -- 更新时间
    ,replace(replace(t1.ckwh,chr(13),''),chr(10),'')  -- 裁定书文号
    ,replace(replace(t1.cpxszl,chr(13),''),chr(10),'')  -- 产品销售种类
    ,replace(replace(t1.feedbackorgname,chr(13),''),chr(10),'')  -- 反馈机构名称
    ,replace(replace(t1.fksjhm,chr(13),''),chr(10),'')  -- 反馈手机号码
    ,replace(replace(t1.feedbackremark,chr(13),''),chr(10),'')  -- 反馈说明
    ,replace(replace(t1.buslicense,chr(13),''),chr(10),'')  -- 工商营业执照
    ,replace(replace(t1.dqh,chr(13),''),chr(10),'')  -- 国家/地区
    ,replace(replace(t1.hclx,chr(13),''),chr(10),'')  -- 核查类型
    ,replace(replace(t1.hcsxje,chr(13),''),chr(10),'')  -- 核查上限金额
    ,replace(replace(t1.thawmode,chr(13),''),chr(10),'')  -- 解除方式
    ,replace(replace(t1.deltellerno,chr(13),''),chr(10),'')  -- 解除柜员
    ,replace(replace(t1.delbrno,chr(13),''),chr(10),'')  -- 解除机构
    ,replace(replace(t1.jrcpbh,chr(13),''),chr(10),'')  -- 金融产品编号
    ,replace(replace(t1.cardno,chr(13),''),chr(10),'')  -- 卡号
    ,replace(replace(t1.kzzt,chr(13),''),chr(10),'')  -- 控制结果
    ,replace(replace(t1.lczh,chr(13),''),chr(10),'')  -- 理财账号
    ,replace(replace(t1.pztxlx,chr(13),''),chr(10),'')  -- 凭证图像类型
    ,replace(replace(t1.pztxmc,chr(13),''),chr(10),'')  -- 凭证图像名称
    ,replace(replace(t1.requesttxcode,chr(13),''),chr(10),'')  -- 请求交易类型编码
    ,replace(replace(t1.responsetxcode,chr(13),''),chr(10),'')  -- 返回交易类型编码
    ,replace(replace(t1.qqrbgdh,chr(13),''),chr(10),'')  -- 请求人办公电话
    ,replace(replace(t1.busiserno,chr(13),''),chr(10),'')  -- 业务流水号
    ,replace(replace(t1.threeinone,chr(13),''),chr(10),'')  -- 三证合一号码
    ,replace(replace(t1.se,chr(13),''),chr(10),'')  -- 申请控制数量/份额/金额
    ,replace(replace(t1.skse,chr(13),''),chr(10),'')  -- 实控数量/份额/金额
    ,replace(replace(t1.sfdysxje,chr(13),''),chr(10),'')  -- 是否超过核查上限金额
    ,replace(replace(t1.sfxd,chr(13),''),chr(10),'')  -- 是否修订
    ,replace(replace(t1.unfrozedtype,chr(13),''),chr(10),'')  -- 系统解冻类型
    ,replace(replace(t1.xcrbgdh,chr(13),''),chr(10),'')  -- 协查人办公电话
    ,replace(replace(t1.ydjah,chr(13),''),chr(10),'')  -- 原冻结案号
    ,replace(replace(t1.zffs,chr(13),''),chr(10),'')  -- 止付处理方式
    ,replace(replace(t1.location,chr(13),''),chr(10),'')  -- 注册地名称
    ,replace(replace(t1.transferoutaccountnumber,chr(13),''),chr(10),'')  -- 转出帐卡号
    ,replace(replace(t1.transferoutaccountname,chr(13),''),chr(10),'')  -- 转出账户名
    ,replace(replace(t1.transferoutbankid,chr(13),''),chr(10),'')  -- 转出账户所属银行机构编码
    ,replace(replace(t1.transferoutbankname,chr(13),''),chr(10),'')  -- 转出账户银行名称
    ,replace(replace(t1.zjhkzh,chr(13),''),chr(10),'')  -- 资金回款账户
    ,replace(replace(t1.orgcode,chr(13),''),chr(10),'')  -- 组织机构代码
    ,replace(replace(t1.froflag,chr(13),''),chr(10),'')  -- 冻结标志
    ,replace(replace(t1.exchangetype,chr(13),''),chr(10),'')  -- 钞汇类型
    ,replace(replace(t1.querycontent,chr(13),''),chr(10),'')  -- 查询内容标识代码：01 账户信息；02 账户交易明细信息；03 账户和账户的交易明细信息；此处值默认为01；
    ,replace(replace(t1.fhbz,chr(13),''),chr(10),'')  -- 复核标志
    ,replace(replace(t1.fklx,chr(13),''),chr(10),'')  -- 反馈标志
    ,replace(replace(t1.isfrozed,chr(13),''),chr(10),'')  -- 是否已解冻:0-否；1-是
    ,to_date('${batch_date}','yyyymmdd') as start_dt  -- 开始日期
    ,to_date('${batch_date}','yyyymmdd') as end_dt  -- 结束日期
    ,' ' as id_mark  -- 删除标识
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.icps_afa_jzck_filedetail t1    --文件明细表
where t1.workdate = '${batch_date}';
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'aml_icps_afa_jzck_filedetail',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);