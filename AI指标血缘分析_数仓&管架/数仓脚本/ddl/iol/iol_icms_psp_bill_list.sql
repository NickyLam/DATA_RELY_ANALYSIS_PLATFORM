/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_psp_bill_list
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_psp_bill_list
whenever sqlerror continue none;
drop table ${iol_schema}.icms_psp_bill_list purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_psp_bill_list(
    serialno varchar2(32) -- 主键
    ,inputbrid varchar2(20) -- 所属分行
    ,overduereceint number(16,2) -- 逾期应收
    ,firstdisbdate varchar2(10) -- 首次放款日期
    ,contamt number(16,2) -- 业务合同金额
    ,loanamount number(16,2) -- 出账金额
    ,loanenddate varchar2(20) -- 到期日
    ,finabrid varchar2(20) -- 账务机构
    ,prdtype varchar2(2) -- 产品类别
    ,repaymentmode varchar2(1) -- 还款方式
    ,billno varchar2(30) -- 借据编号
    ,loanbalance number(16,2) -- 本期余额
    ,cla varchar2(2) -- 上期风险分类
    ,offint number(16,2) -- 表外利息
    ,assuremeansmain varchar2(2) -- 主担保方式
    ,openamt number(16,2) -- 敞口金额
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,doubtfulbalance number(16,2) -- 呆账贷款余额(元)
    ,currencytype varchar2(3) -- 币种
    ,type varchar2(1) -- 借据类别：1、借款人2、保证人
    ,contno varchar2(30) -- 合同编号
    ,defaultflag varchar2(1) -- 违约标志
    ,offintcumu number(16,2) -- 表外欠息
    ,prdname varchar2(60) -- 产品名称
    ,riskopenamt number(16,2) -- 备用主键
    ,loanform varchar2(1) -- 贷款形式
    ,innerintcumu number(16,2) -- 表内欠息
    ,compoundint number(16,2) -- 利息复息
    ,biztype varchar2(20) -- 贷款品种
    ,inneroffint number(16,2) -- 表内转表外利息
    ,cusid varchar2(30) -- 客户代码
    ,cusmanager varchar2(20) -- 客户经理
    ,factuse varchar2(500) -- 实际用途
    ,loanstartdate varchar2(15) -- 出帐日
    ,innerreceint number(16,2) -- 表内应收
    ,serno varchar2(32) -- 任务编号
    ,prdpk varchar2(32) -- 产品主键
    ,delayintcumu number(16,2) -- 欠息累计
    ,overduebalance number(16,2) -- 逾期贷款余额(元)
    ,cusname varchar2(200) -- 客户名称
    ,sluggishbalance number(16,2) -- 呆滞贷款余额(元)
    ,cladate varchar2(10) -- 五级分类日期
    ,biztypesub varchar2(8) -- 业务品种细分
    ,realityirm number(16,9) -- 执行月利率
    ,loanform4 varchar2(2) -- 四级分类标志
    ,normalbalance number(16,2) -- 正常贷款余额(元)
    ,appltype varchar2(1) -- 业务类型
    ,riskamt number(16,2) -- 敞口余额
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.icms_psp_bill_list to ${iml_schema};
grant select on ${iol_schema}.icms_psp_bill_list to ${icl_schema};
grant select on ${iol_schema}.icms_psp_bill_list to ${idl_schema};
grant select on ${iol_schema}.icms_psp_bill_list to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_psp_bill_list is '我行授信实际使用情况';
comment on column ${iol_schema}.icms_psp_bill_list.serialno is '主键';
comment on column ${iol_schema}.icms_psp_bill_list.inputbrid is '所属分行';
comment on column ${iol_schema}.icms_psp_bill_list.overduereceint is '逾期应收';
comment on column ${iol_schema}.icms_psp_bill_list.firstdisbdate is '首次放款日期';
comment on column ${iol_schema}.icms_psp_bill_list.contamt is '业务合同金额';
comment on column ${iol_schema}.icms_psp_bill_list.loanamount is '出账金额';
comment on column ${iol_schema}.icms_psp_bill_list.loanenddate is '到期日';
comment on column ${iol_schema}.icms_psp_bill_list.finabrid is '账务机构';
comment on column ${iol_schema}.icms_psp_bill_list.prdtype is '产品类别';
comment on column ${iol_schema}.icms_psp_bill_list.repaymentmode is '还款方式';
comment on column ${iol_schema}.icms_psp_bill_list.billno is '借据编号';
comment on column ${iol_schema}.icms_psp_bill_list.loanbalance is '本期余额';
comment on column ${iol_schema}.icms_psp_bill_list.cla is '上期风险分类';
comment on column ${iol_schema}.icms_psp_bill_list.offint is '表外利息';
comment on column ${iol_schema}.icms_psp_bill_list.assuremeansmain is '主担保方式';
comment on column ${iol_schema}.icms_psp_bill_list.openamt is '敞口金额';
comment on column ${iol_schema}.icms_psp_bill_list.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_psp_bill_list.doubtfulbalance is '呆账贷款余额(元)';
comment on column ${iol_schema}.icms_psp_bill_list.currencytype is '币种';
comment on column ${iol_schema}.icms_psp_bill_list.type is '借据类别：1、借款人2、保证人';
comment on column ${iol_schema}.icms_psp_bill_list.contno is '合同编号';
comment on column ${iol_schema}.icms_psp_bill_list.defaultflag is '违约标志';
comment on column ${iol_schema}.icms_psp_bill_list.offintcumu is '表外欠息';
comment on column ${iol_schema}.icms_psp_bill_list.prdname is '产品名称';
comment on column ${iol_schema}.icms_psp_bill_list.riskopenamt is '备用主键';
comment on column ${iol_schema}.icms_psp_bill_list.loanform is '贷款形式';
comment on column ${iol_schema}.icms_psp_bill_list.innerintcumu is '表内欠息';
comment on column ${iol_schema}.icms_psp_bill_list.compoundint is '利息复息';
comment on column ${iol_schema}.icms_psp_bill_list.biztype is '贷款品种';
comment on column ${iol_schema}.icms_psp_bill_list.inneroffint is '表内转表外利息';
comment on column ${iol_schema}.icms_psp_bill_list.cusid is '客户代码';
comment on column ${iol_schema}.icms_psp_bill_list.cusmanager is '客户经理';
comment on column ${iol_schema}.icms_psp_bill_list.factuse is '实际用途';
comment on column ${iol_schema}.icms_psp_bill_list.loanstartdate is '出帐日';
comment on column ${iol_schema}.icms_psp_bill_list.innerreceint is '表内应收';
comment on column ${iol_schema}.icms_psp_bill_list.serno is '任务编号';
comment on column ${iol_schema}.icms_psp_bill_list.prdpk is '产品主键';
comment on column ${iol_schema}.icms_psp_bill_list.delayintcumu is '欠息累计';
comment on column ${iol_schema}.icms_psp_bill_list.overduebalance is '逾期贷款余额(元)';
comment on column ${iol_schema}.icms_psp_bill_list.cusname is '客户名称';
comment on column ${iol_schema}.icms_psp_bill_list.sluggishbalance is '呆滞贷款余额(元)';
comment on column ${iol_schema}.icms_psp_bill_list.cladate is '五级分类日期';
comment on column ${iol_schema}.icms_psp_bill_list.biztypesub is '业务品种细分';
comment on column ${iol_schema}.icms_psp_bill_list.realityirm is '执行月利率';
comment on column ${iol_schema}.icms_psp_bill_list.loanform4 is '四级分类标志';
comment on column ${iol_schema}.icms_psp_bill_list.normalbalance is '正常贷款余额(元)';
comment on column ${iol_schema}.icms_psp_bill_list.appltype is '业务类型';
comment on column ${iol_schema}.icms_psp_bill_list.riskamt is '敞口余额';
comment on column ${iol_schema}.icms_psp_bill_list.start_dt is '开始时间';
comment on column ${iol_schema}.icms_psp_bill_list.end_dt is '结束时间';
comment on column ${iol_schema}.icms_psp_bill_list.id_mark is '增删标志';
comment on column ${iol_schema}.icms_psp_bill_list.etl_timestamp is 'ETL处理时间戳';
