/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_acct_trans_fft_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_acct_trans_fft_detail
whenever sqlerror continue none;
drop table ${iol_schema}.icms_acct_trans_fft_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_acct_trans_fft_detail(
    serialno varchar2(32) -- 流水号
    ,objectno varchar2(32) -- 主表流水号
    ,bdserialno varchar2(32) -- 借据编号
    ,salerate number(15,8) -- 卖出利率
    ,resalegather number(24,6) -- 转卖收款金额
    ,remitcomexpense number(24,6) -- 汇入手续费支出
    ,issuebank varchar2(32) -- 开证行
    ,acceptbank varchar2(32) -- 承兑行
    ,classofbenetrade varchar2(32) -- 信用证受益人行业分类
    ,resalematurity date -- 转卖到期日
    ,prepaidamount number(24,6) -- 待摊金额
    ,interbusinessreve number(24,6) -- 中间业务收入
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
grant select on ${iol_schema}.icms_acct_trans_fft_detail to ${iml_schema};
grant select on ${iol_schema}.icms_acct_trans_fft_detail to ${icl_schema};
grant select on ${iol_schema}.icms_acct_trans_fft_detail to ${idl_schema};
grant select on ${iol_schema}.icms_acct_trans_fft_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_acct_trans_fft_detail is '核算交易福费廷转让信息子表';
comment on column ${iol_schema}.icms_acct_trans_fft_detail.serialno is '流水号';
comment on column ${iol_schema}.icms_acct_trans_fft_detail.objectno is '主表流水号';
comment on column ${iol_schema}.icms_acct_trans_fft_detail.bdserialno is '借据编号';
comment on column ${iol_schema}.icms_acct_trans_fft_detail.salerate is '卖出利率';
comment on column ${iol_schema}.icms_acct_trans_fft_detail.resalegather is '转卖收款金额';
comment on column ${iol_schema}.icms_acct_trans_fft_detail.remitcomexpense is '汇入手续费支出';
comment on column ${iol_schema}.icms_acct_trans_fft_detail.issuebank is '开证行';
comment on column ${iol_schema}.icms_acct_trans_fft_detail.acceptbank is '承兑行';
comment on column ${iol_schema}.icms_acct_trans_fft_detail.classofbenetrade is '信用证受益人行业分类';
comment on column ${iol_schema}.icms_acct_trans_fft_detail.resalematurity is '转卖到期日';
comment on column ${iol_schema}.icms_acct_trans_fft_detail.prepaidamount is '待摊金额';
comment on column ${iol_schema}.icms_acct_trans_fft_detail.interbusinessreve is '中间业务收入';
comment on column ${iol_schema}.icms_acct_trans_fft_detail.start_dt is '开始时间';
comment on column ${iol_schema}.icms_acct_trans_fft_detail.end_dt is '结束时间';
comment on column ${iol_schema}.icms_acct_trans_fft_detail.id_mark is '增删标志';
comment on column ${iol_schema}.icms_acct_trans_fft_detail.etl_timestamp is 'ETL处理时间戳';
