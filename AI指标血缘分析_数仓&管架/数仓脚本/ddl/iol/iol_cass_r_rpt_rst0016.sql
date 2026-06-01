/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cass_r_rpt_rst0016
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cass_r_rpt_rst0016
whenever sqlerror continue none;
drop table ${iol_schema}.cass_r_rpt_rst0016 purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cass_r_rpt_rst0016(
    etl_dt_ora date -- 数据日期
    ,com_line varchar2(30) -- 常规条线
    ,manager_org varchar2(60) -- 考核机构
    ,std_prod_no varchar2(60) -- 标准产品编号
    ,curr_cd varchar2(30) -- 币种
    ,header_line_fee number(34,16) -- 总行条线费用
    ,header_other_fee number(34,16) -- 总行非条线费用
    ,branch_line_fee number(34,16) -- 分行条线费用
    ,branch_other_fee number(34,16) -- 分行非条线费用
    ,sub_team_fee number(34,16) -- 支行费用
    ,share_bal_avg_y number(34,16) -- 余额年日均
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
grant select on ${iol_schema}.cass_r_rpt_rst0016 to ${iml_schema};
grant select on ${iol_schema}.cass_r_rpt_rst0016 to ${icl_schema};
grant select on ${iol_schema}.cass_r_rpt_rst0016 to ${idl_schema};
grant select on ${iol_schema}.cass_r_rpt_rst0016 to ${iel_schema};

-- comment
comment on table ${iol_schema}.cass_r_rpt_rst0016 is '管会存贷款五项运营费率表';
comment on column ${iol_schema}.cass_r_rpt_rst0016.etl_dt_ora is '数据日期';
comment on column ${iol_schema}.cass_r_rpt_rst0016.com_line is '常规条线';
comment on column ${iol_schema}.cass_r_rpt_rst0016.manager_org is '考核机构';
comment on column ${iol_schema}.cass_r_rpt_rst0016.std_prod_no is '标准产品编号';
comment on column ${iol_schema}.cass_r_rpt_rst0016.curr_cd is '币种';
comment on column ${iol_schema}.cass_r_rpt_rst0016.header_line_fee is '总行条线费用';
comment on column ${iol_schema}.cass_r_rpt_rst0016.header_other_fee is '总行非条线费用';
comment on column ${iol_schema}.cass_r_rpt_rst0016.branch_line_fee is '分行条线费用';
comment on column ${iol_schema}.cass_r_rpt_rst0016.branch_other_fee is '分行非条线费用';
comment on column ${iol_schema}.cass_r_rpt_rst0016.sub_team_fee is '支行费用';
comment on column ${iol_schema}.cass_r_rpt_rst0016.share_bal_avg_y is '余额年日均';
comment on column ${iol_schema}.cass_r_rpt_rst0016.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cass_r_rpt_rst0016.etl_timestamp is 'ETL处理时间戳';
