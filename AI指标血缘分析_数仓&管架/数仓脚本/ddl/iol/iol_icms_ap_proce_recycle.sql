/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_ap_proce_recycle
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_ap_proce_recycle
whenever sqlerror continue none;
drop table ${iol_schema}.icms_ap_proce_recycle purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ap_proce_recycle(
    recycleno varchar2(64) -- 回收编号
    ,saveflag varchar2(12) -- 保存状态
    ,isquestion varchar2(12) -- 是否有疑议
    ,recyclerate number(24,6) -- 受偿利息
    ,caseno varchar2(64) -- 关联案件项目编号
    ,holdname varchar2(400) -- 财产持有人
    ,recyclecost number(24,6) -- 受偿费用
    ,remark varchar2(1000) -- 备注
    ,inform varchar2(1000) -- 书面通知
    ,updateuserid varchar2(64) -- 更新人编号
    ,tmsp varchar2(64) -- 时间戳
    ,recycleamt number(24,6) -- 要求回收金额
    ,report varchar2(4000) -- 分析建议
    ,recycledate date -- 实际回收日期
    ,enterprise varchar2(1000) -- 破产企业
    ,recyclecapital number(24,6) -- 受偿本金
    ,inputuserid varchar2(64) -- 登记人编号
    ,caseprogramstage varchar2(36) -- 程序阶段信息
    ,inputorgid varchar2(64) -- 登记机构编号
    ,updateorgid varchar2(64) -- 更新机构编号
    ,holdid varchar2(64) -- 财产持有人编号
    ,recyclesum number(24,6) -- 实际受偿金额
    ,inputdate date -- 登记日期
    ,updatedate date -- 更新日期
    ,receiveamt number(24,6) -- 收到金额
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.icms_ap_proce_recycle to ${iml_schema};
grant select on ${iol_schema}.icms_ap_proce_recycle to ${icl_schema};
grant select on ${iol_schema}.icms_ap_proce_recycle to ${idl_schema};
grant select on ${iol_schema}.icms_ap_proce_recycle to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_ap_proce_recycle is '破产财产回收信息表';
comment on column ${iol_schema}.icms_ap_proce_recycle.recycleno is '回收编号';
comment on column ${iol_schema}.icms_ap_proce_recycle.saveflag is '保存状态';
comment on column ${iol_schema}.icms_ap_proce_recycle.isquestion is '是否有疑议';
comment on column ${iol_schema}.icms_ap_proce_recycle.recyclerate is '受偿利息';
comment on column ${iol_schema}.icms_ap_proce_recycle.caseno is '关联案件项目编号';
comment on column ${iol_schema}.icms_ap_proce_recycle.holdname is '财产持有人';
comment on column ${iol_schema}.icms_ap_proce_recycle.recyclecost is '受偿费用';
comment on column ${iol_schema}.icms_ap_proce_recycle.remark is '备注';
comment on column ${iol_schema}.icms_ap_proce_recycle.inform is '书面通知';
comment on column ${iol_schema}.icms_ap_proce_recycle.updateuserid is '更新人编号';
comment on column ${iol_schema}.icms_ap_proce_recycle.tmsp is '时间戳';
comment on column ${iol_schema}.icms_ap_proce_recycle.recycleamt is '要求回收金额';
comment on column ${iol_schema}.icms_ap_proce_recycle.report is '分析建议';
comment on column ${iol_schema}.icms_ap_proce_recycle.recycledate is '实际回收日期';
comment on column ${iol_schema}.icms_ap_proce_recycle.enterprise is '破产企业';
comment on column ${iol_schema}.icms_ap_proce_recycle.recyclecapital is '受偿本金';
comment on column ${iol_schema}.icms_ap_proce_recycle.inputuserid is '登记人编号';
comment on column ${iol_schema}.icms_ap_proce_recycle.caseprogramstage is '程序阶段信息';
comment on column ${iol_schema}.icms_ap_proce_recycle.inputorgid is '登记机构编号';
comment on column ${iol_schema}.icms_ap_proce_recycle.updateorgid is '更新机构编号';
comment on column ${iol_schema}.icms_ap_proce_recycle.holdid is '财产持有人编号';
comment on column ${iol_schema}.icms_ap_proce_recycle.recyclesum is '实际受偿金额';
comment on column ${iol_schema}.icms_ap_proce_recycle.inputdate is '登记日期';
comment on column ${iol_schema}.icms_ap_proce_recycle.updatedate is '更新日期';
comment on column ${iol_schema}.icms_ap_proce_recycle.receiveamt is '收到金额';
comment on column ${iol_schema}.icms_ap_proce_recycle.start_dt is '开始时间';
comment on column ${iol_schema}.icms_ap_proce_recycle.end_dt is '结束时间';
comment on column ${iol_schema}.icms_ap_proce_recycle.id_mark is '增删标志';
comment on column ${iol_schema}.icms_ap_proce_recycle.etl_timestamp is 'ETL处理时间戳';
