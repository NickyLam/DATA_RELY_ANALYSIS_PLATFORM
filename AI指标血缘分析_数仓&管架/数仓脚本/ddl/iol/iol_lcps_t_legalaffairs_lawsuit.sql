/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol lcps_t_legalaffairs_lawsuit
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.lcps_t_legalaffairs_lawsuit
whenever sqlerror continue none;
drop table ${iol_schema}.lcps_t_legalaffairs_lawsuit purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.lcps_t_legalaffairs_lawsuit(
    id varchar2(96) -- 编号
    ,involve_code varchar2(150) -- 涉诉单位
    ,service_type varchar2(15) -- 业务类型
    ,handling_by varchar2(165) -- 经办客户经理
    ,case_type varchar2(15) -- 案件分类
    ,indict_by varchar2(30) -- 起诉(仲裁申请)/被诉(仲裁被申请)/第三人
    ,opposite_by varchar2(1515) -- 相对人(第三人)名称
    ,brief varchar2(1500) -- 案由
    ,involve_amount varchar2(30) -- 诉讼/仲裁涉案金额(万元)
    ,judicial_code varchar2(615) -- 受诉司法机关、仲裁机构
    ,file_date date -- 立案日期
    ,case_stage varchar2(15) -- 案件阶段
    ,trial_result varchar2(30) -- 审理结果
    ,trial_date date -- 终审日期(终审裁决书日期)
    ,compulsion_date date -- 申请强制执行日期
    ,execute_date date -- 终结本案本次执日期
    ,execute_result varchar2(30) -- 执行结果
    ,end_date date -- 清偿完毕日期(终结执行日期)
    ,verification varchar2(15) -- 是否已核销
    ,transfer varchar2(15) -- 是否已债权转让
    ,entrust varchar2(15) -- 是否委托律师
    ,lawyer_code varchar2(150) -- 律师事务所
    ,lawsuit_amount varchar2(30) -- 诉讼费用(万元)
    ,withdraw_amount varchar2(30) -- 收回金额(万元)
    ,case_typ varchar2(15) -- 案件类型
    ,trial_status varchar2(15) -- 审理状态
    ,case_name varchar2(1515) -- 案件名称
    ,case_num varchar2(96) -- 审批号
    ,case_no varchar2(315) -- 案号
    ,case_code varchar2(30) -- 案件编号
    ,status varchar2(2) -- 状态（0正常 1删除 2停用）
    ,create_by varchar2(96) -- 创建者
    ,create_date timestamp -- 创建时间
    ,update_by varchar2(96) -- 更新者
    ,update_date timestamp -- 更新时间
    ,remarks varchar2(1500) -- 备注信息
    ,corp_code varchar2(96) -- 租户代码
    ,corp_name varchar2(200) -- 租户名称
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
grant select on ${iol_schema}.lcps_t_legalaffairs_lawsuit to ${iml_schema};
grant select on ${iol_schema}.lcps_t_legalaffairs_lawsuit to ${icl_schema};
grant select on ${iol_schema}.lcps_t_legalaffairs_lawsuit to ${idl_schema};
grant select on ${iol_schema}.lcps_t_legalaffairs_lawsuit to ${iel_schema};

-- comment
comment on table ${iol_schema}.lcps_t_legalaffairs_lawsuit is '诉讼(仲裁)案件管理表';
comment on column ${iol_schema}.lcps_t_legalaffairs_lawsuit.id is '编号';
comment on column ${iol_schema}.lcps_t_legalaffairs_lawsuit.involve_code is '涉诉单位';
comment on column ${iol_schema}.lcps_t_legalaffairs_lawsuit.service_type is '业务类型';
comment on column ${iol_schema}.lcps_t_legalaffairs_lawsuit.handling_by is '经办客户经理';
comment on column ${iol_schema}.lcps_t_legalaffairs_lawsuit.case_type is '案件分类';
comment on column ${iol_schema}.lcps_t_legalaffairs_lawsuit.indict_by is '起诉(仲裁申请)/被诉(仲裁被申请)/第三人';
comment on column ${iol_schema}.lcps_t_legalaffairs_lawsuit.opposite_by is '相对人(第三人)名称';
comment on column ${iol_schema}.lcps_t_legalaffairs_lawsuit.brief is '案由';
comment on column ${iol_schema}.lcps_t_legalaffairs_lawsuit.involve_amount is '诉讼/仲裁涉案金额(万元)';
comment on column ${iol_schema}.lcps_t_legalaffairs_lawsuit.judicial_code is '受诉司法机关、仲裁机构';
comment on column ${iol_schema}.lcps_t_legalaffairs_lawsuit.file_date is '立案日期';
comment on column ${iol_schema}.lcps_t_legalaffairs_lawsuit.case_stage is '案件阶段';
comment on column ${iol_schema}.lcps_t_legalaffairs_lawsuit.trial_result is '审理结果';
comment on column ${iol_schema}.lcps_t_legalaffairs_lawsuit.trial_date is '终审日期(终审裁决书日期)';
comment on column ${iol_schema}.lcps_t_legalaffairs_lawsuit.compulsion_date is '申请强制执行日期';
comment on column ${iol_schema}.lcps_t_legalaffairs_lawsuit.execute_date is '终结本案本次执日期';
comment on column ${iol_schema}.lcps_t_legalaffairs_lawsuit.execute_result is '执行结果';
comment on column ${iol_schema}.lcps_t_legalaffairs_lawsuit.end_date is '清偿完毕日期(终结执行日期)';
comment on column ${iol_schema}.lcps_t_legalaffairs_lawsuit.verification is '是否已核销';
comment on column ${iol_schema}.lcps_t_legalaffairs_lawsuit.transfer is '是否已债权转让';
comment on column ${iol_schema}.lcps_t_legalaffairs_lawsuit.entrust is '是否委托律师';
comment on column ${iol_schema}.lcps_t_legalaffairs_lawsuit.lawyer_code is '律师事务所';
comment on column ${iol_schema}.lcps_t_legalaffairs_lawsuit.lawsuit_amount is '诉讼费用(万元)';
comment on column ${iol_schema}.lcps_t_legalaffairs_lawsuit.withdraw_amount is '收回金额(万元)';
comment on column ${iol_schema}.lcps_t_legalaffairs_lawsuit.case_typ is '案件类型';
comment on column ${iol_schema}.lcps_t_legalaffairs_lawsuit.trial_status is '审理状态';
comment on column ${iol_schema}.lcps_t_legalaffairs_lawsuit.case_name is '案件名称';
comment on column ${iol_schema}.lcps_t_legalaffairs_lawsuit.case_num is '审批号';
comment on column ${iol_schema}.lcps_t_legalaffairs_lawsuit.case_no is '案号';
comment on column ${iol_schema}.lcps_t_legalaffairs_lawsuit.case_code is '案件编号';
comment on column ${iol_schema}.lcps_t_legalaffairs_lawsuit.status is '状态（0正常 1删除 2停用）';
comment on column ${iol_schema}.lcps_t_legalaffairs_lawsuit.create_by is '创建者';
comment on column ${iol_schema}.lcps_t_legalaffairs_lawsuit.create_date is '创建时间';
comment on column ${iol_schema}.lcps_t_legalaffairs_lawsuit.update_by is '更新者';
comment on column ${iol_schema}.lcps_t_legalaffairs_lawsuit.update_date is '更新时间';
comment on column ${iol_schema}.lcps_t_legalaffairs_lawsuit.remarks is '备注信息';
comment on column ${iol_schema}.lcps_t_legalaffairs_lawsuit.corp_code is '租户代码';
comment on column ${iol_schema}.lcps_t_legalaffairs_lawsuit.corp_name is '租户名称';
comment on column ${iol_schema}.lcps_t_legalaffairs_lawsuit.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.lcps_t_legalaffairs_lawsuit.etl_timestamp is 'ETL处理时间戳';
