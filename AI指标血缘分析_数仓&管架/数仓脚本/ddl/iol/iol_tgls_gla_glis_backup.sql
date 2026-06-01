/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_gla_glis_backup
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_gla_glis_backup
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_gla_glis_backup purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_gla_glis_backup(
    stacid number(19) -- 账套标记
    ,systid varchar2(4) -- 系统
    ,acctdt varchar2(8) -- 账务日期
    ,brchcd varchar2(16) -- 机构代码（总账机构）
    ,itemcd varchar2(20) -- 科目代码
    ,centcd varchar2(16) -- 责任中心
    ,prsncd varchar2(16) -- 职员
    ,custcd varchar2(16) -- 客户
    ,prducd varchar2(16) -- 产品
    ,prlncd varchar2(16) -- 产品线
    ,acctno varchar2(30) -- 账户
    ,assis0 varchar2(6) -- 渠道编号
    ,assis1 varchar2(12) -- 产品编号
    ,assis2 varchar2(30) -- 辅助核算2（自定义）
    ,assis3 varchar2(30) -- 辅助核算3（自定义）
    ,assis4 varchar2(30) -- 辅助核算4（自定义）
    ,assis5 varchar2(30) -- 辅助核算5（自定义）
    ,assis6 varchar2(30) -- 辅助核算6（自定义）
    ,assis7 varchar2(30) -- 辅助核算7（自定义）
    ,assis8 varchar2(30) -- 辅助核算8（自定义）
    ,assis9 varchar2(30) -- 辅助核算9（自定义）
    ,geldtp varchar2(1) -- 总账类型(d日总帐m月总帐q季总帐y年总帐)
    ,crcycd varchar2(3) -- 币种代码
    ,drltbl number(20,2) -- 借方上期余额
    ,crltbl number(20,2) -- 贷方上期余额
    ,drtsam number(20,2) -- 借方本期发生额
    ,drtsnm number -- 借方本期发生笔数
    ,crtsam number(20,2) -- 贷方本期发生额
    ,crtsnm number -- 贷方本期发生笔数
    ,drctbl number(20,2) -- 借方本期余额
    ,crctbl number(20,2) -- 贷方本期余额
    ,blncdn varchar2(9) -- 当前余额方向
    ,onlnbl number(20,2) -- 当前余额
    ,lastdn varchar2(9) -- 上期余额方向
    ,lastbl number(20,2) -- 上期余额
    ,drtsaj number(20,2) -- 借方外币折算调整值
    ,crtsaj number(20,2) -- 贷方外币折算调整值
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
grant select on ${iol_schema}.tgls_gla_glis_backup to ${iml_schema};
grant select on ${iol_schema}.tgls_gla_glis_backup to ${icl_schema};
grant select on ${iol_schema}.tgls_gla_glis_backup to ${idl_schema};
grant select on ${iol_schema}.tgls_gla_glis_backup to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_gla_glis_backup is '总账表备份表';
comment on column ${iol_schema}.tgls_gla_glis_backup.stacid is '账套标记';
comment on column ${iol_schema}.tgls_gla_glis_backup.systid is '系统';
comment on column ${iol_schema}.tgls_gla_glis_backup.acctdt is '账务日期';
comment on column ${iol_schema}.tgls_gla_glis_backup.brchcd is '机构代码（总账机构）';
comment on column ${iol_schema}.tgls_gla_glis_backup.itemcd is '科目代码';
comment on column ${iol_schema}.tgls_gla_glis_backup.centcd is '责任中心';
comment on column ${iol_schema}.tgls_gla_glis_backup.prsncd is '职员';
comment on column ${iol_schema}.tgls_gla_glis_backup.custcd is '客户';
comment on column ${iol_schema}.tgls_gla_glis_backup.prducd is '产品';
comment on column ${iol_schema}.tgls_gla_glis_backup.prlncd is '产品线';
comment on column ${iol_schema}.tgls_gla_glis_backup.acctno is '账户';
comment on column ${iol_schema}.tgls_gla_glis_backup.assis0 is '渠道编号';
comment on column ${iol_schema}.tgls_gla_glis_backup.assis1 is '产品编号';
comment on column ${iol_schema}.tgls_gla_glis_backup.assis2 is '辅助核算2（自定义）';
comment on column ${iol_schema}.tgls_gla_glis_backup.assis3 is '辅助核算3（自定义）';
comment on column ${iol_schema}.tgls_gla_glis_backup.assis4 is '辅助核算4（自定义）';
comment on column ${iol_schema}.tgls_gla_glis_backup.assis5 is '辅助核算5（自定义）';
comment on column ${iol_schema}.tgls_gla_glis_backup.assis6 is '辅助核算6（自定义）';
comment on column ${iol_schema}.tgls_gla_glis_backup.assis7 is '辅助核算7（自定义）';
comment on column ${iol_schema}.tgls_gla_glis_backup.assis8 is '辅助核算8（自定义）';
comment on column ${iol_schema}.tgls_gla_glis_backup.assis9 is '辅助核算9（自定义）';
comment on column ${iol_schema}.tgls_gla_glis_backup.geldtp is '总账类型(d日总帐m月总帐q季总帐y年总帐)';
comment on column ${iol_schema}.tgls_gla_glis_backup.crcycd is '币种代码';
comment on column ${iol_schema}.tgls_gla_glis_backup.drltbl is '借方上期余额';
comment on column ${iol_schema}.tgls_gla_glis_backup.crltbl is '贷方上期余额';
comment on column ${iol_schema}.tgls_gla_glis_backup.drtsam is '借方本期发生额';
comment on column ${iol_schema}.tgls_gla_glis_backup.drtsnm is '借方本期发生笔数';
comment on column ${iol_schema}.tgls_gla_glis_backup.crtsam is '贷方本期发生额';
comment on column ${iol_schema}.tgls_gla_glis_backup.crtsnm is '贷方本期发生笔数';
comment on column ${iol_schema}.tgls_gla_glis_backup.drctbl is '借方本期余额';
comment on column ${iol_schema}.tgls_gla_glis_backup.crctbl is '贷方本期余额';
comment on column ${iol_schema}.tgls_gla_glis_backup.blncdn is '当前余额方向';
comment on column ${iol_schema}.tgls_gla_glis_backup.onlnbl is '当前余额';
comment on column ${iol_schema}.tgls_gla_glis_backup.lastdn is '上期余额方向';
comment on column ${iol_schema}.tgls_gla_glis_backup.lastbl is '上期余额';
comment on column ${iol_schema}.tgls_gla_glis_backup.drtsaj is '借方外币折算调整值';
comment on column ${iol_schema}.tgls_gla_glis_backup.crtsaj is '贷方外币折算调整值';
comment on column ${iol_schema}.tgls_gla_glis_backup.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.tgls_gla_glis_backup.etl_timestamp is 'ETL处理时间戳';
