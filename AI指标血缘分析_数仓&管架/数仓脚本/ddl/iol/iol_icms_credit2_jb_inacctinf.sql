/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_credit2_jb_inacctinf
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_credit2_jb_inacctinf
whenever sqlerror continue none;
drop table ${iol_schema}.icms_credit2_jb_inacctinf purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_credit2_jb_inacctinf(
    fivecateadjdate varchar2(20) -- 五级分类认定日期
    ,opendate varchar2(20) -- 开户日期
    ,specefctdate varchar2(20) -- 分期额度生效日期
    ,rptdate varchar2(50) -- 信息报告日期
    ,acctspectrstdspnsgmt_updflag varchar2(2) -- 特殊交易说明段上报标志
    ,loanamt varchar2(20) -- 借款金额
    ,repayfreqcy varchar2(20) -- 还款频率
    ,fundsou varchar2(20) -- 业务经营类型
    ,pridacctbal varchar2(20) -- 本期账单余额
    ,oved31_60princ varchar2(20) -- 逾期31-60天未归还本金
    ,rpyprct varchar2(20) -- 实际还款百分比
    ,name varchar2(100) -- 借款人姓名
    ,idtype varchar2(10) -- 借款人证件类型
    ,acctbsinfsgmt_updflag varchar2(20) -- 基本信息信息段上报标志
    ,origcreditorinfsgmt_updflag varchar2(2) -- 初始债权说明段上报标志
    ,usedamt varchar2(20) -- 已使用额度
    ,ovedprinc180 varchar2(20) -- 逾期180天以上未归还本金
    ,acctmthlyblginfsgmt_updflag varchar2(2) -- 月度表现信息段上报标志
    ,guarmode varchar2(20) -- 担保方式
    ,mcc varchar2(60) -- 授信协议标识码
    ,rltrepymtinfsgmt_updflag varchar2(2) -- 相关还款责任人段上报标志
    ,acctcode varchar2(60) -- 账户标识码
    ,rptdatecode varchar2(20) -- 报告时点说明代码
    ,busidtllines varchar2(4) -- 借贷业务种类细分
    ,totoverd varchar2(20) -- 当前逾期总额
    ,cagoftrdinfdata varchar2(2000) -- 特殊交易说明段
    ,acctcredline varchar2(20) -- 信用额度
    ,initcredname varchar2(80) -- 初始债权人名称
    ,specline varchar2(20) -- 大额专项分期额度
    ,firsthouloanflag varchar2(4) -- 是否为首套住房贷款
    ,origdbtcate varchar2(8) -- 原债务种类
    ,extra_info varchar2(2000) -- 扩展字段
    ,rpystatus varchar2(20) -- 当前还款状态
    ,overdprinc varchar2(20) -- 当前逾期本金
    ,oved61_90princ varchar2(20) -- 逾期61-90天未归还本金
    ,acctcredsgmt_updflag varchar2(20) -- 授信额度信息段上报标志
    ,specprdsgmt_updflag varchar2(2) -- 大额专项分期信息段上报标志
    ,creditid varchar2(20) -- 卡片标识号
    ,latrpyamt varchar2(20) -- 最近一次实际还款金额
    ,actrpyamt varchar2(20) -- 本月实际还款金额
    ,repaymode varchar2(20) -- 还款方式
    ,initcredorgnm varchar2(18) -- 初始债权人机构代码
    ,idnum varchar2(20) -- 借款人证件号码
    ,repayprd varchar2(20) -- 还款期数
    ,specenddate varchar2(20) -- 分期额度到期日期
    ,create_time varchar2(20) -- 入库时间
    ,busilines varchar2(4) -- 借贷业务大类
    ,loanform varchar2(20) -- 贷款发放形式
    ,acctbal varchar2(20) -- 余额
    ,infrectype varchar2(3) -- 信息记录类型
    ,loanconcode varchar2(200) -- 贷款合同编号
    ,ccnm varchar2(20) -- 抵质押合同个数
    ,cagoftrdnm varchar2(20) -- 交易个数
    ,notisubal varchar2(20) -- 未出单的大额专项分期余额
    ,applybusidist varchar2(20) -- 业务申请地行政区划代码
    ,othrepyguarway varchar2(20) -- 其他还款保证方式
    ,remrepprd varchar2(20) -- 剩余还款期数
    ,fivecate varchar2(20) -- 五级分类
    ,motgacltalctrctinfsgmt_updflag varchar2(2) -- 抵质押物信息段上报标志
    ,oved91_180princ varchar2(20) -- 逾期91-180天未归还本金
    ,acctdbtinfsgmt_updflag varchar2(2) -- 非月度表现信息段上报标志
    ,month varchar2(8) -- 月份
    ,currpyamt varchar2(20) -- 本月应还款金额
    ,overdprd varchar2(20) -- 当前逾期期数
    ,ovedrawbaove180 varchar2(20) -- 透支180天以上未还余额
    ,settdate varchar2(20) -- 结算/应还款日
    ,flag varchar2(10) -- 分次放款标志
    ,cy varchar2(20) -- 币种
    ,duedate varchar2(20) -- 到期日期
    ,closedate varchar2(20) -- 账户关闭日期
    ,usedinstamt varchar2(20) -- 已用分期金额
    ,mngmtorgcode varchar2(20) -- 业务管理机构代码
    ,rltrepymtnm varchar2(20) -- 责任人个数
    ,accttype varchar2(6) -- 账户类型
    ,assettrandflag varchar2(20) -- 资产转让标志
    ,initrpysts varchar2(20) -- 债权转移时的还款状态
    ,latrpydate varchar2(20) -- 最近一次实际还款日期
    ,rltrepymtinfdata varchar2(2000) -- 相关还款责任人段
    ,cccinfdata varchar2(2000) -- 抵质押物信息段
    ,acctstatus varchar2(20) -- 账户状态
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
grant select on ${iol_schema}.icms_credit2_jb_inacctinf to ${iml_schema};
grant select on ${iol_schema}.icms_credit2_jb_inacctinf to ${icl_schema};
grant select on ${iol_schema}.icms_credit2_jb_inacctinf to ${idl_schema};
grant select on ${iol_schema}.icms_credit2_jb_inacctinf to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_credit2_jb_inacctinf is '人民银行个人征信元数据：个人借贷账户记录';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.fivecateadjdate is '五级分类认定日期';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.opendate is '开户日期';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.specefctdate is '分期额度生效日期';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.rptdate is '信息报告日期';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.acctspectrstdspnsgmt_updflag is '特殊交易说明段上报标志';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.loanamt is '借款金额';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.repayfreqcy is '还款频率';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.fundsou is '业务经营类型';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.pridacctbal is '本期账单余额';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.oved31_60princ is '逾期31-60天未归还本金';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.rpyprct is '实际还款百分比';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.name is '借款人姓名';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.idtype is '借款人证件类型';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.acctbsinfsgmt_updflag is '基本信息信息段上报标志';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.origcreditorinfsgmt_updflag is '初始债权说明段上报标志';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.usedamt is '已使用额度';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.ovedprinc180 is '逾期180天以上未归还本金';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.acctmthlyblginfsgmt_updflag is '月度表现信息段上报标志';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.guarmode is '担保方式';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.mcc is '授信协议标识码';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.rltrepymtinfsgmt_updflag is '相关还款责任人段上报标志';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.acctcode is '账户标识码';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.rptdatecode is '报告时点说明代码';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.busidtllines is '借贷业务种类细分';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.totoverd is '当前逾期总额';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.cagoftrdinfdata is '特殊交易说明段';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.acctcredline is '信用额度';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.initcredname is '初始债权人名称';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.specline is '大额专项分期额度';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.firsthouloanflag is '是否为首套住房贷款';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.origdbtcate is '原债务种类';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.extra_info is '扩展字段';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.rpystatus is '当前还款状态';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.overdprinc is '当前逾期本金';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.oved61_90princ is '逾期61-90天未归还本金';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.acctcredsgmt_updflag is '授信额度信息段上报标志';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.specprdsgmt_updflag is '大额专项分期信息段上报标志';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.creditid is '卡片标识号';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.latrpyamt is '最近一次实际还款金额';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.actrpyamt is '本月实际还款金额';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.repaymode is '还款方式';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.initcredorgnm is '初始债权人机构代码';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.idnum is '借款人证件号码';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.repayprd is '还款期数';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.specenddate is '分期额度到期日期';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.create_time is '入库时间';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.busilines is '借贷业务大类';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.loanform is '贷款发放形式';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.acctbal is '余额';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.infrectype is '信息记录类型';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.loanconcode is '贷款合同编号';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.ccnm is '抵质押合同个数';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.cagoftrdnm is '交易个数';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.notisubal is '未出单的大额专项分期余额';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.applybusidist is '业务申请地行政区划代码';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.othrepyguarway is '其他还款保证方式';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.remrepprd is '剩余还款期数';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.fivecate is '五级分类';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.motgacltalctrctinfsgmt_updflag is '抵质押物信息段上报标志';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.oved91_180princ is '逾期91-180天未归还本金';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.acctdbtinfsgmt_updflag is '非月度表现信息段上报标志';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.month is '月份';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.currpyamt is '本月应还款金额';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.overdprd is '当前逾期期数';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.ovedrawbaove180 is '透支180天以上未还余额';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.settdate is '结算/应还款日';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.flag is '分次放款标志';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.cy is '币种';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.duedate is '到期日期';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.closedate is '账户关闭日期';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.usedinstamt is '已用分期金额';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.mngmtorgcode is '业务管理机构代码';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.rltrepymtnm is '责任人个数';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.accttype is '账户类型';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.assettrandflag is '资产转让标志';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.initrpysts is '债权转移时的还款状态';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.latrpydate is '最近一次实际还款日期';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.rltrepymtinfdata is '相关还款责任人段';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.cccinfdata is '抵质押物信息段';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.acctstatus is '账户状态';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_credit2_jb_inacctinf.etl_timestamp is 'ETL处理时间戳';
