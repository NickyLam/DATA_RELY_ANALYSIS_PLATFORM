/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml pty_indv_ext_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.pty_indv_ext_info
whenever sqlerror continue none;
drop table ${iml_schema}.pty_indv_ext_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_indv_ext_info(
    party_id varchar2(60) -- 当事人编号
    ,lp_id varchar2(60) -- 法人编号
    ,risk_estim_level_cd varchar2(30) -- 客户风险承受能力评估等级代码
    ,risk_estim_valid_tm timestamp -- 风险评估有效时间
    ,cmplt_cnter_risk_estim_flg varchar2(10) -- 完成柜面风险评估标志
    ,risk_estim_quesn_edit_id varchar2(250) -- 风险评估问卷版本编号
    ,risk_estim_quesn_scor number(30,2) -- 风险评估问卷得分
    ,risk_estim_update_tm timestamp -- 风险评估更新时间
    ,risk_estim_chn_cd varchar2(30) -- 风险评估渠道代码
    ,use_camp_wish_flg varchar2(10) -- 使用营销意愿标志
    ,qual_invtor_cert_flg varchar2(10) -- 合格投资者认证标志
    ,qual_invtor_vlid_tenor varchar2(10) -- 合格投资者有效期限
    ,qual_invtor_src_chn_cd varchar2(30) -- 合格投资者来源渠道代码
    ,create_teller_id varchar2(100) -- 创建柜员编号
    ,create_org_id varchar2(100) -- 创建机构编号
    ,create_chn_cd varchar2(30) -- 创建渠道代码
    ,curr_cd varchar2(30) -- 币种代码
    ,indus_type_cd varchar2(30) -- 行业类型代码
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (end_dt)
(
   partition p_default values ('default')
   (
         subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
         ,subpartition p_default_20991231 values (to_date('20991231','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.pty_indv_ext_info to ${icl_schema};
grant select on ${iml_schema}.pty_indv_ext_info to ${idl_schema};
grant select on ${iml_schema}.pty_indv_ext_info to ${iel_schema};

-- comment
comment on table ${iml_schema}.pty_indv_ext_info is '个人当事人扩展信息';
comment on column ${iml_schema}.pty_indv_ext_info.party_id is '当事人编号';
comment on column ${iml_schema}.pty_indv_ext_info.lp_id is '法人编号';
comment on column ${iml_schema}.pty_indv_ext_info.risk_estim_level_cd is '客户风险承受能力评估等级代码';
comment on column ${iml_schema}.pty_indv_ext_info.risk_estim_valid_tm is '风险评估有效时间';
comment on column ${iml_schema}.pty_indv_ext_info.cmplt_cnter_risk_estim_flg is '完成柜面风险评估标志';
comment on column ${iml_schema}.pty_indv_ext_info.risk_estim_quesn_edit_id is '风险评估问卷版本编号';
comment on column ${iml_schema}.pty_indv_ext_info.risk_estim_quesn_scor is '风险评估问卷得分';
comment on column ${iml_schema}.pty_indv_ext_info.risk_estim_update_tm is '风险评估更新时间';
comment on column ${iml_schema}.pty_indv_ext_info.risk_estim_chn_cd is '风险评估渠道代码';
comment on column ${iml_schema}.pty_indv_ext_info.use_camp_wish_flg is '使用营销意愿标志';
comment on column ${iml_schema}.pty_indv_ext_info.qual_invtor_cert_flg is '合格投资者认证标志';
comment on column ${iml_schema}.pty_indv_ext_info.qual_invtor_vlid_tenor is '合格投资者有效期限';
comment on column ${iml_schema}.pty_indv_ext_info.qual_invtor_src_chn_cd is '合格投资者来源渠道代码';
comment on column ${iml_schema}.pty_indv_ext_info.create_teller_id is '创建柜员编号';
comment on column ${iml_schema}.pty_indv_ext_info.create_org_id is '创建机构编号';
comment on column ${iml_schema}.pty_indv_ext_info.create_chn_cd is '创建渠道代码';
comment on column ${iml_schema}.pty_indv_ext_info.curr_cd is '币种代码';
comment on column ${iml_schema}.pty_indv_ext_info.indus_type_cd is '行业类型代码';
comment on column ${iml_schema}.pty_indv_ext_info.start_dt is '开始时间';
comment on column ${iml_schema}.pty_indv_ext_info.end_dt is '结束时间';
comment on column ${iml_schema}.pty_indv_ext_info.id_mark is '增删标志';
comment on column ${iml_schema}.pty_indv_ext_info.src_table_name is '源表名称';
comment on column ${iml_schema}.pty_indv_ext_info.job_cd is '任务编码';
comment on column ${iml_schema}.pty_indv_ext_info.etl_timestamp is 'ETL处理时间戳';
