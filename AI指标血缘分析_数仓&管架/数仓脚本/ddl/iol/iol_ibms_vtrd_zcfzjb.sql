/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_vtrd_zcfzjb
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_vtrd_zcfzjb
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_vtrd_zcfzjb purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_vtrd_zcfzjb(
    beg_date varchar2(30) -- beg_date
    ,ordid number(22,0) -- ordid
    ,title varchar2(300) -- title
    ,all_real_cp number(22,0) -- 汇总_real_cp
    ,all_minus_cp number(22,0) -- 汇总_minus_cp
    ,zb_real_cp number(22,0) -- 总部_real_cp
    ,zb_minus_cp number(22,0) -- 总部_minus_cp
    ,gz_real_cp number(22,0) -- 广州团队_real_cp
    ,gz_minus_cp number(22,0) -- 广州团队_minus_cp
    ,sz_real_cp number(22,0) -- 深圳团队_real_cp
    ,sz_minus_cp number(22,0) -- 深圳团队_minus_cp
    ,szsfq_real_cp number(22,0) -- 深圳示范区_real_cp
    ,szsfq_minus_cp number(22,0) -- 深圳示范区_minus_cp
    ,fs_real_cp number(22,0) -- 佛山团队_real_cp
    ,fs_minus_cp number(22,0) -- 佛山团队_minus_cp
    ,dg_real_cp number(22,0) -- 东莞团队_real_cp
    ,dg_minus_cp number(22,0) -- 东莞团队_minus_cp
    ,st_real_cp number(22,0) -- 汕头团队_real_cp
    ,st_minus_cp number(22,0) -- 汕头团队_minus_cp
    ,jm_real_cp number(22,0) -- 江门团队_real_cp
    ,jm_minus_cp number(22,0) -- 江门团队_minus_cp
    ,zh_real_cp number(22,0) -- 珠海团队_real_cp
    ,zh_minus_cp number(22,0) -- 珠海团队_minus_cp
    ,hz_real_cp number(22,0) -- 惠州团队_real_cp
    ,hz_minus_cp number(22,0) -- 惠州团队_minus_cp
    ,zs_real_cp number(22,0) -- 中山团队_real_cp
    ,zs_minus_cp number(22,0) -- 中山团队_minus_cp
    ,zq_real_cp number(22,0) -- 肇庆团队_real_cp
    ,zq_minus_cp number(22,0) -- 肇庆团队_minus_cp
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
grant select on ${iol_schema}.ibms_vtrd_zcfzjb to ${iml_schema};
grant select on ${iol_schema}.ibms_vtrd_zcfzjb to ${icl_schema};
grant select on ${iol_schema}.ibms_vtrd_zcfzjb to ${idl_schema};
grant select on ${iol_schema}.ibms_vtrd_zcfzjb to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_vtrd_zcfzjb is '资产负债简表';
comment on column ${iol_schema}.ibms_vtrd_zcfzjb.beg_date is 'beg_date';
comment on column ${iol_schema}.ibms_vtrd_zcfzjb.ordid is 'ordid';
comment on column ${iol_schema}.ibms_vtrd_zcfzjb.title is 'title';
comment on column ${iol_schema}.ibms_vtrd_zcfzjb.all_real_cp is '汇总_real_cp';
comment on column ${iol_schema}.ibms_vtrd_zcfzjb.all_minus_cp is '汇总_minus_cp';
comment on column ${iol_schema}.ibms_vtrd_zcfzjb.zb_real_cp is '总部_real_cp';
comment on column ${iol_schema}.ibms_vtrd_zcfzjb.zb_minus_cp is '总部_minus_cp';
comment on column ${iol_schema}.ibms_vtrd_zcfzjb.gz_real_cp is '广州团队_real_cp';
comment on column ${iol_schema}.ibms_vtrd_zcfzjb.gz_minus_cp is '广州团队_minus_cp';
comment on column ${iol_schema}.ibms_vtrd_zcfzjb.sz_real_cp is '深圳团队_real_cp';
comment on column ${iol_schema}.ibms_vtrd_zcfzjb.sz_minus_cp is '深圳团队_minus_cp';
comment on column ${iol_schema}.ibms_vtrd_zcfzjb.szsfq_real_cp is '深圳示范区_real_cp';
comment on column ${iol_schema}.ibms_vtrd_zcfzjb.szsfq_minus_cp is '深圳示范区_minus_cp';
comment on column ${iol_schema}.ibms_vtrd_zcfzjb.fs_real_cp is '佛山团队_real_cp';
comment on column ${iol_schema}.ibms_vtrd_zcfzjb.fs_minus_cp is '佛山团队_minus_cp';
comment on column ${iol_schema}.ibms_vtrd_zcfzjb.dg_real_cp is '东莞团队_real_cp';
comment on column ${iol_schema}.ibms_vtrd_zcfzjb.dg_minus_cp is '东莞团队_minus_cp';
comment on column ${iol_schema}.ibms_vtrd_zcfzjb.st_real_cp is '汕头团队_real_cp';
comment on column ${iol_schema}.ibms_vtrd_zcfzjb.st_minus_cp is '汕头团队_minus_cp';
comment on column ${iol_schema}.ibms_vtrd_zcfzjb.jm_real_cp is '江门团队_real_cp';
comment on column ${iol_schema}.ibms_vtrd_zcfzjb.jm_minus_cp is '江门团队_minus_cp';
comment on column ${iol_schema}.ibms_vtrd_zcfzjb.zh_real_cp is '珠海团队_real_cp';
comment on column ${iol_schema}.ibms_vtrd_zcfzjb.zh_minus_cp is '珠海团队_minus_cp';
comment on column ${iol_schema}.ibms_vtrd_zcfzjb.hz_real_cp is '惠州团队_real_cp';
comment on column ${iol_schema}.ibms_vtrd_zcfzjb.hz_minus_cp is '惠州团队_minus_cp';
comment on column ${iol_schema}.ibms_vtrd_zcfzjb.zs_real_cp is '中山团队_real_cp';
comment on column ${iol_schema}.ibms_vtrd_zcfzjb.zs_minus_cp is '中山团队_minus_cp';
comment on column ${iol_schema}.ibms_vtrd_zcfzjb.zq_real_cp is '肇庆团队_real_cp';
comment on column ${iol_schema}.ibms_vtrd_zcfzjb.zq_minus_cp is '肇庆团队_minus_cp';
comment on column ${iol_schema}.ibms_vtrd_zcfzjb.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ibms_vtrd_zcfzjb.etl_timestamp is 'ETL处理时间戳';
