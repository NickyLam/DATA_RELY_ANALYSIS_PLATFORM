/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_pty_corp_oper_situ_h
CreateDate: 20221106
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_pty_corp_oper_situ_h purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_pty_corp_oper_situ_h(
etl_dt date --数据日期
,sorc_sys_cd varchar2(10) --源系统代码
,net_asset number(30,2) --企业净资产
,anl_inco number(30,2) --年收入
,tot_sell_lmt number(30,2) --总销售额
,tot_asset number(30,2) --企业总资产
,cbrc_sb_flg varchar2(10) --银监小企业标志
,start_dt date --开始时间
,end_dt date --结束时间
,id_mark varchar2(10) --增删标志
,party_id varchar2(60) --当事人编号
,lp_id varchar2(60) --法人编号

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.oass_pty_corp_oper_situ_h to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_pty_corp_oper_situ_h is '企业经营情况历史';
comment on column ${idl_schema}.oass_pty_corp_oper_situ_h.etl_dt is '数据日期';
comment on column ${idl_schema}.oass_pty_corp_oper_situ_h.sorc_sys_cd is '源系统代码';
comment on column ${idl_schema}.oass_pty_corp_oper_situ_h.net_asset is '企业净资产';
comment on column ${idl_schema}.oass_pty_corp_oper_situ_h.anl_inco is '年收入';
comment on column ${idl_schema}.oass_pty_corp_oper_situ_h.tot_sell_lmt is '总销售额';
comment on column ${idl_schema}.oass_pty_corp_oper_situ_h.tot_asset is '企业总资产';
comment on column ${idl_schema}.oass_pty_corp_oper_situ_h.cbrc_sb_flg is '银监小企业标志';
comment on column ${idl_schema}.oass_pty_corp_oper_situ_h.start_dt is '开始时间';
comment on column ${idl_schema}.oass_pty_corp_oper_situ_h.end_dt is '结束时间';
comment on column ${idl_schema}.oass_pty_corp_oper_situ_h.id_mark is '增删标志';
comment on column ${idl_schema}.oass_pty_corp_oper_situ_h.party_id is '当事人编号';
comment on column ${idl_schema}.oass_pty_corp_oper_situ_h.lp_id is '法人编号';

