/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_pty_party_work_info_h
CreateDate: 20230404
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_pty_party_work_info_h purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_pty_party_work_info_h(
etl_dt date --数据日期
,sorc_sys_cd varchar2(10) --源系统代码
,corp_bl_induty_type_cd varchar2(30) --单位所属行业类型代码
,tel_num varchar2(100) --电话号码
,work_unit_addr varchar2(1000) --工作单位地址
,work_unit_name varchar2(500) --工作单位名称
,work_unit_char_cd varchar2(250) --工作单位性质代码
,work_mon_inco number(30,2) --工作月收入
,anl_inco number(30,2) --年收入
,employ_year_cnt number(10,0) --雇佣年数
,emply_status_cd varchar2(30) --雇用状态代码
,dimission_dt date --离职日期
,empyt_dt date --入职日期
,zip_cd varchar2(60) --邮政编码
,title_cd varchar2(30) --
,post_cd varchar2(60) --
,career_cd varchar2(10) --职业代码
,corp_work_start_year date --加入本单位日期
,corp_iac_que_rest_cd varchar2(10) --单位工商查询结果代码
,corp_rgst_dt date --单位注册日期
,corp_rgst_cap_gold number(30,2) --单位注册资本金
,work_unit_sspf_flg varchar2(10) --工作单位与社保公积金一致标志
,work_record_cd varchar2(10) --工作履历代码
,work_char_cd varchar2(10) --工作性质代码
,employ_type_cd varchar2(10) --雇佣类型代码
,indus_risk_cate_cd varchar2(10) --行业风险类别代码
,trading_corp_flg varchar2(10) --贸易型企业标志
,curr_indus_obtain_emply_years number(10,0) --目前行业从业年限
,serving_years number(22,0) --任职年限
,local_dept varchar2(100) --所在部门
,other_career varchar2(100) --其他职业
,now_corp_work_years number(22,0) --现单位工作年限
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
grant select on ${idl_schema}.oass_pty_party_work_info_h to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_pty_party_work_info_h is '当事人工作信息历史';
comment on column ${idl_schema}.oass_pty_party_work_info_h.etl_dt is '数据日期';
comment on column ${idl_schema}.oass_pty_party_work_info_h.sorc_sys_cd is '源系统代码';
comment on column ${idl_schema}.oass_pty_party_work_info_h.corp_bl_induty_type_cd is '单位所属行业类型代码';
comment on column ${idl_schema}.oass_pty_party_work_info_h.tel_num is '电话号码';
comment on column ${idl_schema}.oass_pty_party_work_info_h.work_unit_addr is '工作单位地址';
comment on column ${idl_schema}.oass_pty_party_work_info_h.work_unit_name is '工作单位名称';
comment on column ${idl_schema}.oass_pty_party_work_info_h.work_unit_char_cd is '工作单位性质代码';
comment on column ${idl_schema}.oass_pty_party_work_info_h.work_mon_inco is '工作月收入';
comment on column ${idl_schema}.oass_pty_party_work_info_h.anl_inco is '年收入';
comment on column ${idl_schema}.oass_pty_party_work_info_h.employ_year_cnt is '雇佣年数';
comment on column ${idl_schema}.oass_pty_party_work_info_h.emply_status_cd is '雇用状态代码';
comment on column ${idl_schema}.oass_pty_party_work_info_h.dimission_dt is '离职日期';
comment on column ${idl_schema}.oass_pty_party_work_info_h.empyt_dt is '入职日期';
comment on column ${idl_schema}.oass_pty_party_work_info_h.zip_cd is '邮政编码';
comment on column ${idl_schema}.oass_pty_party_work_info_h.title_cd is '';
comment on column ${idl_schema}.oass_pty_party_work_info_h.post_cd is '';
comment on column ${idl_schema}.oass_pty_party_work_info_h.career_cd is '职业代码';
comment on column ${idl_schema}.oass_pty_party_work_info_h.corp_work_start_year is '加入本单位日期';
comment on column ${idl_schema}.oass_pty_party_work_info_h.corp_iac_que_rest_cd is '单位工商查询结果代码';
comment on column ${idl_schema}.oass_pty_party_work_info_h.corp_rgst_dt is '单位注册日期';
comment on column ${idl_schema}.oass_pty_party_work_info_h.corp_rgst_cap_gold is '单位注册资本金';
comment on column ${idl_schema}.oass_pty_party_work_info_h.work_unit_sspf_flg is '工作单位与社保公积金一致标志';
comment on column ${idl_schema}.oass_pty_party_work_info_h.work_record_cd is '工作履历代码';
comment on column ${idl_schema}.oass_pty_party_work_info_h.work_char_cd is '工作性质代码';
comment on column ${idl_schema}.oass_pty_party_work_info_h.employ_type_cd is '雇佣类型代码';
comment on column ${idl_schema}.oass_pty_party_work_info_h.indus_risk_cate_cd is '行业风险类别代码';
comment on column ${idl_schema}.oass_pty_party_work_info_h.trading_corp_flg is '贸易型企业标志';
comment on column ${idl_schema}.oass_pty_party_work_info_h.curr_indus_obtain_emply_years is '目前行业从业年限';
comment on column ${idl_schema}.oass_pty_party_work_info_h.serving_years is '任职年限';
comment on column ${idl_schema}.oass_pty_party_work_info_h.local_dept is '所在部门';
comment on column ${idl_schema}.oass_pty_party_work_info_h.other_career is '其他职业';
comment on column ${idl_schema}.oass_pty_party_work_info_h.now_corp_work_years is '现单位工作年限';
comment on column ${idl_schema}.oass_pty_party_work_info_h.start_dt is '开始时间';
comment on column ${idl_schema}.oass_pty_party_work_info_h.end_dt is '结束时间';
comment on column ${idl_schema}.oass_pty_party_work_info_h.id_mark is '增删标志';
comment on column ${idl_schema}.oass_pty_party_work_info_h.party_id is '当事人编号';
comment on column ${idl_schema}.oass_pty_party_work_info_h.lp_id is '法人编号';

