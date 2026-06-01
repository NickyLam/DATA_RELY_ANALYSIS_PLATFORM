/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_pty_party_family_situ_h
CreateDate: 20221106
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_pty_party_family_situ_h purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_pty_party_family_situ_h(
etl_dt date --数据日期
,loc_resd_years number(10,0) --本地居住年限
,local_estate_flg varchar2(10) --当地房产标志
,local_soci_secu_flg varchar2(10) --当地社保标志
,house_val_cd varchar2(30) --房屋价值代码
,prov_pulation_type_cd varchar2(10) --供养人口类型代码
,rpr_char_cd varchar2(100) --户籍性质代码
,resdnt_status_cd varchar2(10) --居住状况代码
,child_number_cd varchar2(10) --子女人数代码
,free_car_situ_cd varchar2(10) --自由汽车状况代码
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
grant select on ${idl_schema}.oass_pty_party_family_situ_h to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_pty_party_family_situ_h is '当事人家庭状况历史';
comment on column ${idl_schema}.oass_pty_party_family_situ_h.etl_dt is '数据日期';
comment on column ${idl_schema}.oass_pty_party_family_situ_h.loc_resd_years is '本地居住年限';
comment on column ${idl_schema}.oass_pty_party_family_situ_h.local_estate_flg is '当地房产标志';
comment on column ${idl_schema}.oass_pty_party_family_situ_h.local_soci_secu_flg is '当地社保标志';
comment on column ${idl_schema}.oass_pty_party_family_situ_h.house_val_cd is '房屋价值代码';
comment on column ${idl_schema}.oass_pty_party_family_situ_h.prov_pulation_type_cd is '供养人口类型代码';
comment on column ${idl_schema}.oass_pty_party_family_situ_h.rpr_char_cd is '户籍性质代码';
comment on column ${idl_schema}.oass_pty_party_family_situ_h.resdnt_status_cd is '居住状况代码';
comment on column ${idl_schema}.oass_pty_party_family_situ_h.child_number_cd is '子女人数代码';
comment on column ${idl_schema}.oass_pty_party_family_situ_h.free_car_situ_cd is '自由汽车状况代码';
comment on column ${idl_schema}.oass_pty_party_family_situ_h.start_dt is '开始时间';
comment on column ${idl_schema}.oass_pty_party_family_situ_h.end_dt is '结束时间';
comment on column ${idl_schema}.oass_pty_party_family_situ_h.id_mark is '增删标志';
comment on column ${idl_schema}.oass_pty_party_family_situ_h.party_id is '当事人编号';
comment on column ${idl_schema}.oass_pty_party_family_situ_h.lp_id is '法人编号';

