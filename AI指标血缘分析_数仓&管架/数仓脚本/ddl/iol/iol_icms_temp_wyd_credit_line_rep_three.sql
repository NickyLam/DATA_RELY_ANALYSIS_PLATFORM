/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_temp_wyd_credit_line_rep_three
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_temp_wyd_credit_line_rep_three
whenever sqlerror continue none;
drop table ${iol_schema}.icms_temp_wyd_credit_line_rep_three purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_temp_wyd_credit_line_rep_three(
    datadt varchar2(10) -- 数据日期
    ,limitno varchar2(64) -- 额度编号
    ,custid varchar2(40) -- 客户号
    ,custidtype varchar2(20) -- 客户证件类型
    ,custidno varchar2(30) -- 客户证件号码
    ,custname varchar2(60) -- 客户名称
    ,ccycd varchar2(10) -- 币种
    ,orgid varchar2(20) -- 机构号
    ,circulflag varchar2(1) -- 循环额度标志
    ,startdate varchar2(10) -- 授信起始日期
    ,maturitydate varchar2(10) -- 额度到期日期
    ,creditline number(20,4) -- 总授信额度
    ,credittype varchar2(10) -- 授信业务类型
    ,begindate varchar2(10) -- 生效日期
    ,trandate varchar2(10) -- 发生日期
    ,initdate varchar2(10) -- 授信开始日期
    ,status varchar2(10) -- 协议状态
    ,freezeflag varchar2(10) -- 冻结标志
    ,adjustdate varchar2(10) -- 续期日期
    ,extenddate varchar2(10) -- 更新时间
    ,availablecredit number(20,4) -- 可用额度
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
grant select on ${iol_schema}.icms_temp_wyd_credit_line_rep_three to ${iml_schema};
grant select on ${iol_schema}.icms_temp_wyd_credit_line_rep_three to ${icl_schema};
grant select on ${iol_schema}.icms_temp_wyd_credit_line_rep_three to ${idl_schema};
grant select on ${iol_schema}.icms_temp_wyd_credit_line_rep_three to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_temp_wyd_credit_line_rep_three is '额度信息报表中间表03';
comment on column ${iol_schema}.icms_temp_wyd_credit_line_rep_three.datadt is '数据日期';
comment on column ${iol_schema}.icms_temp_wyd_credit_line_rep_three.limitno is '额度编号';
comment on column ${iol_schema}.icms_temp_wyd_credit_line_rep_three.custid is '客户号';
comment on column ${iol_schema}.icms_temp_wyd_credit_line_rep_three.custidtype is '客户证件类型';
comment on column ${iol_schema}.icms_temp_wyd_credit_line_rep_three.custidno is '客户证件号码';
comment on column ${iol_schema}.icms_temp_wyd_credit_line_rep_three.custname is '客户名称';
comment on column ${iol_schema}.icms_temp_wyd_credit_line_rep_three.ccycd is '币种';
comment on column ${iol_schema}.icms_temp_wyd_credit_line_rep_three.orgid is '机构号';
comment on column ${iol_schema}.icms_temp_wyd_credit_line_rep_three.circulflag is '循环额度标志';
comment on column ${iol_schema}.icms_temp_wyd_credit_line_rep_three.startdate is '授信起始日期';
comment on column ${iol_schema}.icms_temp_wyd_credit_line_rep_three.maturitydate is '额度到期日期';
comment on column ${iol_schema}.icms_temp_wyd_credit_line_rep_three.creditline is '总授信额度';
comment on column ${iol_schema}.icms_temp_wyd_credit_line_rep_three.credittype is '授信业务类型';
comment on column ${iol_schema}.icms_temp_wyd_credit_line_rep_three.begindate is '生效日期';
comment on column ${iol_schema}.icms_temp_wyd_credit_line_rep_three.trandate is '发生日期';
comment on column ${iol_schema}.icms_temp_wyd_credit_line_rep_three.initdate is '授信开始日期';
comment on column ${iol_schema}.icms_temp_wyd_credit_line_rep_three.status is '协议状态';
comment on column ${iol_schema}.icms_temp_wyd_credit_line_rep_three.freezeflag is '冻结标志';
comment on column ${iol_schema}.icms_temp_wyd_credit_line_rep_three.adjustdate is '续期日期';
comment on column ${iol_schema}.icms_temp_wyd_credit_line_rep_three.extenddate is '更新时间';
comment on column ${iol_schema}.icms_temp_wyd_credit_line_rep_three.availablecredit is '可用额度';
comment on column ${iol_schema}.icms_temp_wyd_credit_line_rep_three.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_temp_wyd_credit_line_rep_three.etl_timestamp is 'ETL处理时间戳';
