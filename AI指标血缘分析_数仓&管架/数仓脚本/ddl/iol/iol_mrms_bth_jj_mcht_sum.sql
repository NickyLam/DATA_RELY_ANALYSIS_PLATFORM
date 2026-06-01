/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mrms_bth_jj_mcht_sum
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mrms_bth_jj_mcht_sum
whenever sqlerror continue none;
drop table ${iol_schema}.mrms_bth_jj_mcht_sum purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mrms_bth_jj_mcht_sum(
    inter_brh_code varchar2(15) -- 内部分行代码
    ,trandt varchar2(12) -- 交易日期
    ,acq_inst_id varchar2(30) -- 收单机构代码
    ,seqno varchar2(9) -- 序列号
    ,fund_id varchar2(23) -- 基金编号
    ,sett_account varchar2(45) -- 清算账号
    ,sett_na varchar2(90) -- 结算模式
    ,totcnt number(15,2) -- 总笔数
    ,totamt number(15,2) -- 总笔数
    ,succcnt number(15,2) -- 成功笔数
    ,succamt number(15,2) -- 对账成功笔数
    ,failcnt number(15,2) -- 失败笔数
    ,failamt number(15,2) -- 失败笔数
    ,unkncnt number(15,2) -- 未明交易笔数
    ,unknamt number(15,2) -- 未明交易金额
    ,onlnbl number(19,2) -- 代付还款金额
    ,chckamt number(19,2) -- 业务确认金额
    ,chckuser varchar2(30) -- 确认人编号
    ,chckstat varchar2(6) -- 确认状态 y-已确认  n-未确认  z-无需确认
    ,cbsamt number(15,2) -- 实际划账金额
    ,inneracct varchar2(60) -- 清算内部户
    ,inneracna varchar2(180) -- 清算内部户户名
    ,acct_flag varchar2(3) -- 是否已划账
    ,host_ssn varchar2(75) -- 核心流水号
    ,res_desc varchar2(300) -- 错误信息
    ,reserve varchar2(30) -- 保留区域
    ,reserve1 varchar2(75) -- 保留区域
    ,used_amt number(15,2) -- 基金公司已使用额度
    ,fee_amt number(15,2) -- 手续费金额
    ,yl_amt number(15,2) -- 银联成功金额
    ,settlmt_date varchar2(12) -- 清算日期
    ,fund_amt number(15,2) -- 基金额度
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
grant select on ${iol_schema}.mrms_bth_jj_mcht_sum to ${iml_schema};
grant select on ${iol_schema}.mrms_bth_jj_mcht_sum to ${icl_schema};
grant select on ${iol_schema}.mrms_bth_jj_mcht_sum to ${idl_schema};
grant select on ${iol_schema}.mrms_bth_jj_mcht_sum to ${iel_schema};

-- comment
comment on table ${iol_schema}.mrms_bth_jj_mcht_sum is '基金垫资汇总表';
comment on column ${iol_schema}.mrms_bth_jj_mcht_sum.inter_brh_code is '内部分行代码';
comment on column ${iol_schema}.mrms_bth_jj_mcht_sum.trandt is '交易日期';
comment on column ${iol_schema}.mrms_bth_jj_mcht_sum.acq_inst_id is '收单机构代码';
comment on column ${iol_schema}.mrms_bth_jj_mcht_sum.seqno is '序列号';
comment on column ${iol_schema}.mrms_bth_jj_mcht_sum.fund_id is '基金编号';
comment on column ${iol_schema}.mrms_bth_jj_mcht_sum.sett_account is '清算账号';
comment on column ${iol_schema}.mrms_bth_jj_mcht_sum.sett_na is '结算模式';
comment on column ${iol_schema}.mrms_bth_jj_mcht_sum.totcnt is '总笔数';
comment on column ${iol_schema}.mrms_bth_jj_mcht_sum.totamt is '总笔数';
comment on column ${iol_schema}.mrms_bth_jj_mcht_sum.succcnt is '成功笔数';
comment on column ${iol_schema}.mrms_bth_jj_mcht_sum.succamt is '对账成功笔数';
comment on column ${iol_schema}.mrms_bth_jj_mcht_sum.failcnt is '失败笔数';
comment on column ${iol_schema}.mrms_bth_jj_mcht_sum.failamt is '失败笔数';
comment on column ${iol_schema}.mrms_bth_jj_mcht_sum.unkncnt is '未明交易笔数';
comment on column ${iol_schema}.mrms_bth_jj_mcht_sum.unknamt is '未明交易金额';
comment on column ${iol_schema}.mrms_bth_jj_mcht_sum.onlnbl is '代付还款金额';
comment on column ${iol_schema}.mrms_bth_jj_mcht_sum.chckamt is '业务确认金额';
comment on column ${iol_schema}.mrms_bth_jj_mcht_sum.chckuser is '确认人编号';
comment on column ${iol_schema}.mrms_bth_jj_mcht_sum.chckstat is '确认状态 y-已确认  n-未确认  z-无需确认';
comment on column ${iol_schema}.mrms_bth_jj_mcht_sum.cbsamt is '实际划账金额';
comment on column ${iol_schema}.mrms_bth_jj_mcht_sum.inneracct is '清算内部户';
comment on column ${iol_schema}.mrms_bth_jj_mcht_sum.inneracna is '清算内部户户名';
comment on column ${iol_schema}.mrms_bth_jj_mcht_sum.acct_flag is '是否已划账';
comment on column ${iol_schema}.mrms_bth_jj_mcht_sum.host_ssn is '核心流水号';
comment on column ${iol_schema}.mrms_bth_jj_mcht_sum.res_desc is '错误信息';
comment on column ${iol_schema}.mrms_bth_jj_mcht_sum.reserve is '保留区域';
comment on column ${iol_schema}.mrms_bth_jj_mcht_sum.reserve1 is '保留区域';
comment on column ${iol_schema}.mrms_bth_jj_mcht_sum.used_amt is '基金公司已使用额度';
comment on column ${iol_schema}.mrms_bth_jj_mcht_sum.fee_amt is '手续费金额';
comment on column ${iol_schema}.mrms_bth_jj_mcht_sum.yl_amt is '银联成功金额';
comment on column ${iol_schema}.mrms_bth_jj_mcht_sum.settlmt_date is '清算日期';
comment on column ${iol_schema}.mrms_bth_jj_mcht_sum.fund_amt is '基金额度';
comment on column ${iol_schema}.mrms_bth_jj_mcht_sum.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mrms_bth_jj_mcht_sum.etl_timestamp is 'ETL处理时间戳';
