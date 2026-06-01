/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_agt_col_guar_cont_info
CreateDate: 20221106
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_agt_col_guar_cont_info purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_agt_col_guar_cont_info(
etl_dt date --数据日期
,guar_amt number(30,2) --担保金额
,guar_amt_convt_cny number(30,2) --担保金额_折人民币
,guar_cont_id varchar2(60) --担保合同编号
,guar_cont_type_cd varchar2(10) --担保合同类型代码
,guartor_id varchar2(60) --担保人编号
,guartor_type_cd varchar2(10) --担保人类型代码
,guartor_rg_num varchar2(60) --担保人地区号
,strip_line_cd varchar2(10) --条线代码
,cont_type_cd varchar2(10) --合同类型代码
,setup_dt date --建立日期
,setup_ps_id varchar2(100) --建立人编号
,guar_curr_cd varchar2(10) --担保币种代码
,guartor_rating varchar2(10) --担保人评级
,data_src_cd varchar2(10) --数据来源代码
,effect_flg varchar2(10) --生效标志
,exp_day date --到期日
,exp_status_cd varchar2(10) --到期状态代码
,higt_pm_cont_flg varchar2(10) --最高抵质押合同标志
,mender_id varchar2(100) --修改人编号
,modif_dt date --修改日期
,begin_day date --起始日
,start_dt date --开始时间
,end_dt date --结束时间
,id_mark varchar2(10) --增删标志
,agt_id varchar2(60) --协议编号
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
grant select on ${idl_schema}.oass_agt_col_guar_cont_info to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_agt_col_guar_cont_info is '押品担保合同信息表';
comment on column ${idl_schema}.oass_agt_col_guar_cont_info.etl_dt is '数据日期';
comment on column ${idl_schema}.oass_agt_col_guar_cont_info.guar_amt is '担保金额';
comment on column ${idl_schema}.oass_agt_col_guar_cont_info.guar_amt_convt_cny is '担保金额_折人民币';
comment on column ${idl_schema}.oass_agt_col_guar_cont_info.guar_cont_id is '担保合同编号';
comment on column ${idl_schema}.oass_agt_col_guar_cont_info.guar_cont_type_cd is '担保合同类型代码';
comment on column ${idl_schema}.oass_agt_col_guar_cont_info.guartor_id is '担保人编号';
comment on column ${idl_schema}.oass_agt_col_guar_cont_info.guartor_type_cd is '担保人类型代码';
comment on column ${idl_schema}.oass_agt_col_guar_cont_info.guartor_rg_num is '担保人地区号';
comment on column ${idl_schema}.oass_agt_col_guar_cont_info.strip_line_cd is '条线代码';
comment on column ${idl_schema}.oass_agt_col_guar_cont_info.cont_type_cd is '合同类型代码';
comment on column ${idl_schema}.oass_agt_col_guar_cont_info.setup_dt is '建立日期';
comment on column ${idl_schema}.oass_agt_col_guar_cont_info.setup_ps_id is '建立人编号';
comment on column ${idl_schema}.oass_agt_col_guar_cont_info.guar_curr_cd is '担保币种代码';
comment on column ${idl_schema}.oass_agt_col_guar_cont_info.guartor_rating is '担保人评级';
comment on column ${idl_schema}.oass_agt_col_guar_cont_info.data_src_cd is '数据来源代码';
comment on column ${idl_schema}.oass_agt_col_guar_cont_info.effect_flg is '生效标志';
comment on column ${idl_schema}.oass_agt_col_guar_cont_info.exp_day is '到期日';
comment on column ${idl_schema}.oass_agt_col_guar_cont_info.exp_status_cd is '到期状态代码';
comment on column ${idl_schema}.oass_agt_col_guar_cont_info.higt_pm_cont_flg is '最高抵质押合同标志';
comment on column ${idl_schema}.oass_agt_col_guar_cont_info.mender_id is '修改人编号';
comment on column ${idl_schema}.oass_agt_col_guar_cont_info.modif_dt is '修改日期';
comment on column ${idl_schema}.oass_agt_col_guar_cont_info.begin_day is '起始日';
comment on column ${idl_schema}.oass_agt_col_guar_cont_info.start_dt is '开始时间';
comment on column ${idl_schema}.oass_agt_col_guar_cont_info.end_dt is '结束时间';
comment on column ${idl_schema}.oass_agt_col_guar_cont_info.id_mark is '增删标志';
comment on column ${idl_schema}.oass_agt_col_guar_cont_info.agt_id is '协议编号';
comment on column ${idl_schema}.oass_agt_col_guar_cont_info.lp_id is '法人编号';

