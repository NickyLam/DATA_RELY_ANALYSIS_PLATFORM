/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_tmp_zjbk_inacctinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_tmp_zjbk_inacctinfo
whenever sqlerror continue none;
drop table ${iol_schema}.icms_tmp_zjbk_inacctinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_tmp_zjbk_inacctinfo(
    infrectype varchar2(3) -- 信息记录类型
    ,accttype varchar2(6) -- 账户类型
    ,acctcode varchar2(60) -- 账户标识码
    ,rptdate varchar2(32) -- 信息报告日期
    ,rptdatecode varchar2(4) -- 报告时点说明代码
    ,name varchar2(100) -- 借款人姓名
    ,idtype varchar2(4) -- 借款人证件类型
    ,idnum varchar2(20) -- 借款人证件号码
    ,mngmtorgcode varchar2(14) -- 业务管理机构代码
    ,acctbsinfsgmt_updflag varchar2(2) -- 基本信息信息段上报标志
    ,rltrepymtinfsgmt_updflag varchar2(2) -- 相关还款责任人段上报标志
    ,motgacltalctrctinfsgmt_updflag varchar2(2) -- 抵质押物信息段上报标志
    ,acctcredsgmt_updflag varchar2(2) -- 授信额度信息段上报标志
    ,origcreditorinfsgmt_updflag varchar2(2) -- 初始债权说明段上报标志
    ,acctmthlyblginfsgmt_updflag varchar2(2) -- 月度表现信息段上报标志
    ,specprdsgmt_updflag varchar2(2) -- 大额专项分期信息段上报标志
    ,acctdbtinfsgmt_updflag varchar2(2) -- 非月度表现信息段上报标志
    ,acctspectrstdspnsgmt_updflag varchar2(2) -- 特殊交易说明段上报标志
    ,busilines varchar2(4) -- 借贷业务大类
    ,busidtllines varchar2(4) -- 借贷业务种类细分
    ,opendate varchar2(32) -- 开户日期
    ,cy varchar2(3) -- 币种
    ,acctcredline varchar2(32) -- 信用额度
    ,loanamt varchar2(32) -- 借款金额
    ,flag varchar2(1) -- 分次放款标志
    ,duedate varchar2(32) -- 到期日期
    ,repaymode varchar2(2) -- 还款方式
    ,repayfreqcy varchar2(2) -- 还款频率
    ,repayprd varchar2(32) -- 还款期数
    ,applybusidist varchar2(6) -- 业务申请地行政区划代码
    ,guarmode varchar2(1) -- 担保方式
    ,othrepyguarway varchar2(1) -- 其他还款保证方式
    ,assettrandflag varchar2(1) -- 资产转让标志
    ,fundsou varchar2(2) -- 业务经营类型
    ,loanform varchar2(1) -- 贷款发放形式
    ,creditid varchar2(4) -- 卡片标识号
    ,loanconcode varchar2(200) -- 贷款合同编号
    ,firsthouloanflag varchar2(4) -- 是否为首套住房贷款
    ,rltrepymtnm varchar2(32) -- 责任人个数
    ,rltrepymtinfdata varchar2(2000) -- 相关还款责任人段
    ,ccnm varchar2(32) -- 抵质押合同个数
    ,cccinfdata varchar2(2000) -- 抵质押物信息段
    ,mcc varchar2(60) -- 授信协议标识码
    ,initcredname varchar2(80) -- 初始债权人名称
    ,initcredorgnm varchar2(18) -- 初始债权人机构代码
    ,origdbtcate varchar2(8) -- 原债务种类
    ,initrpysts varchar2(1) -- 债权转移时的还款状态
    ,month varchar2(8) -- 月份
    ,settdate varchar2(32) -- 结算/应还款日
    ,acctstatus varchar2(2) -- 账户状态
    ,acctbal varchar2(32) -- 余额
    ,pridacctbal varchar2(32) -- 本期账单余额
    ,usedamt varchar2(32) -- 已使用额度
    ,notisubal varchar2(32) -- 未出单的大额专项分期余额
    ,remrepprd varchar2(32) -- 剩余还款期数
    ,fivecate varchar2(1) -- 五级分类
    ,fivecateadjdate varchar2(32) -- 五级分类认定日期
    ,rpystatus varchar2(1) -- 当前还款状态
    ,rpyprct varchar2(32) -- 实际还款百分比
    ,overdprd varchar2(32) -- 当前逾期期数
    ,totoverd varchar2(32) -- 当前逾期总额
    ,overdprinc varchar2(32) -- 当前逾期本金
    ,oved31_60princ varchar2(32) -- 逾期31-60天未归还本金
    ,oved61_90princ varchar2(32) -- 逾期61-90天未归还本金
    ,oved91_180princ varchar2(32) -- 逾期91-180天未归还本金
    ,ovedprinc180 varchar2(32) -- 逾期180天以上未归还本金
    ,ovedrawbaove180 varchar2(32) -- 透支180天以上未还余额
    ,currpyamt varchar2(32) -- 本月应还款金额
    ,actrpyamt varchar2(32) -- 本月实际还款金额
    ,latrpyamt varchar2(32) -- 最近一次实际还款金额
    ,latrpydate varchar2(32) -- 最近一次实际还款日期
    ,closedate varchar2(32) -- 账户关闭日期
    ,specline varchar2(32) -- 大额专项分期额度
    ,specefctdate varchar2(32) -- 分期额度生效日期
    ,specenddate varchar2(32) -- 分期额度到期日期
    ,usedinstamt varchar2(32) -- 已用分期金额
    ,cagoftrdnm varchar2(32) -- 交易个数
    ,cagoftrdinfdata varchar2(2000) -- 特殊交易说明段
    ,extra_info varchar2(2000) -- 扩展字段
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
grant select on ${iol_schema}.icms_tmp_zjbk_inacctinfo to ${iml_schema};
grant select on ${iol_schema}.icms_tmp_zjbk_inacctinfo to ${icl_schema};
grant select on ${iol_schema}.icms_tmp_zjbk_inacctinfo to ${idl_schema};
grant select on ${iol_schema}.icms_tmp_zjbk_inacctinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_tmp_zjbk_inacctinfo is '人行征信文件中间数据-个人借贷账户信息记录表';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo.infrectype is '信息记录类型';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo.accttype is '账户类型';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo.acctcode is '账户标识码';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo.rptdate is '信息报告日期';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo.rptdatecode is '报告时点说明代码';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo.name is '借款人姓名';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo.idtype is '借款人证件类型';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo.idnum is '借款人证件号码';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo.mngmtorgcode is '业务管理机构代码';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo.acctbsinfsgmt_updflag is '基本信息信息段上报标志';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo.rltrepymtinfsgmt_updflag is '相关还款责任人段上报标志';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo.motgacltalctrctinfsgmt_updflag is '抵质押物信息段上报标志';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo.acctcredsgmt_updflag is '授信额度信息段上报标志';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo.origcreditorinfsgmt_updflag is '初始债权说明段上报标志';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo.acctmthlyblginfsgmt_updflag is '月度表现信息段上报标志';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo.specprdsgmt_updflag is '大额专项分期信息段上报标志';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo.acctdbtinfsgmt_updflag is '非月度表现信息段上报标志';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo.acctspectrstdspnsgmt_updflag is '特殊交易说明段上报标志';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo.busilines is '借贷业务大类';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo.busidtllines is '借贷业务种类细分';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo.opendate is '开户日期';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo.cy is '币种';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo.acctcredline is '信用额度';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo.loanamt is '借款金额';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo.flag is '分次放款标志';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo.duedate is '到期日期';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo.repaymode is '还款方式';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo.repayfreqcy is '还款频率';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo.repayprd is '还款期数';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo.applybusidist is '业务申请地行政区划代码';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo.guarmode is '担保方式';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo.othrepyguarway is '其他还款保证方式';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo.assettrandflag is '资产转让标志';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo.fundsou is '业务经营类型';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo.loanform is '贷款发放形式';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo.creditid is '卡片标识号';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo.loanconcode is '贷款合同编号';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo.firsthouloanflag is '是否为首套住房贷款';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo.rltrepymtnm is '责任人个数';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo.rltrepymtinfdata is '相关还款责任人段';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo.ccnm is '抵质押合同个数';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo.cccinfdata is '抵质押物信息段';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo.mcc is '授信协议标识码';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo.initcredname is '初始债权人名称';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo.initcredorgnm is '初始债权人机构代码';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo.origdbtcate is '原债务种类';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo.initrpysts is '债权转移时的还款状态';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo.month is '月份';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo.settdate is '结算/应还款日';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo.acctstatus is '账户状态';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo.acctbal is '余额';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo.pridacctbal is '本期账单余额';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo.usedamt is '已使用额度';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo.notisubal is '未出单的大额专项分期余额';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo.remrepprd is '剩余还款期数';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo.fivecate is '五级分类';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo.fivecateadjdate is '五级分类认定日期';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo.rpystatus is '当前还款状态';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo.rpyprct is '实际还款百分比';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo.overdprd is '当前逾期期数';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo.totoverd is '当前逾期总额';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo.overdprinc is '当前逾期本金';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo.oved31_60princ is '逾期31-60天未归还本金';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo.oved61_90princ is '逾期61-90天未归还本金';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo.oved91_180princ is '逾期91-180天未归还本金';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo.ovedprinc180 is '逾期180天以上未归还本金';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo.ovedrawbaove180 is '透支180天以上未还余额';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo.currpyamt is '本月应还款金额';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo.actrpyamt is '本月实际还款金额';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo.latrpyamt is '最近一次实际还款金额';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo.latrpydate is '最近一次实际还款日期';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo.closedate is '账户关闭日期';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo.specline is '大额专项分期额度';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo.specefctdate is '分期额度生效日期';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo.specenddate is '分期额度到期日期';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo.usedinstamt is '已用分期金额';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo.cagoftrdnm is '交易个数';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo.cagoftrdinfdata is '特殊交易说明段';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo.extra_info is '扩展字段';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo.etl_timestamp is 'ETL处理时间戳';
