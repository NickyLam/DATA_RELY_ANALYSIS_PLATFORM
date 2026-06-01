/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_group_member_relative
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_group_member_relative
whenever sqlerror continue none;
drop table ${iol_schema}.icms_group_member_relative purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_group_member_relative(
    serialno varchar2(32) -- 流水号
    ,oldmembercustomerid varchar2(32) -- 原集团成员编号
    ,updateuserid varchar2(32) -- 更新人
    ,membertype varchar2(80) -- 成员类型
    ,updatedate date -- 更新日期
    ,parentmemberid varchar2(32) -- 父成员编号
    ,oldparentrelationtype varchar2(18) -- 原父成员关系类型
    ,groupid varchar2(32) -- 客户编号
    ,oldmembername varchar2(80) -- 原成员名称
    ,oldmembertype varchar2(80) -- 原成员类型
    ,inputuserid varchar2(32) -- 登记人
    ,migtflag varchar2(80) -- 
    ,inputdate date -- 登记日期
    ,parentrelationtype varchar2(18) -- 父成员关系类型
    ,membername varchar2(200) -- 成员单位名称
    ,reviseflag varchar2(18) -- 修订标志
    ,membercustomerid varchar2(16) -- 成员客户编号
    ,membercertid varchar2(32) -- 成员证件号
    ,inputorgid varchar2(32) -- 登记单位
    ,remark varchar2(500) -- 备注
    ,groupcustomertype varchar2(80) -- 集团客户类型
    ,certid_ent04 varchar2(32) -- 组织机构代码证(风险预警)
    ,updateorgid varchar2(32) -- 更新机构
    ,sharevalue number(24,8) -- 持股比例
    ,membercerttype varchar2(80) -- 成员证件类型
    ,oldsharevalue number(24,8) -- 原持股比例
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
grant select on ${iol_schema}.icms_group_member_relative to ${iml_schema};
grant select on ${iol_schema}.icms_group_member_relative to ${icl_schema};
grant select on ${iol_schema}.icms_group_member_relative to ${idl_schema};
grant select on ${iol_schema}.icms_group_member_relative to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_group_member_relative is '集群当前成员集群当前成员';
comment on column ${iol_schema}.icms_group_member_relative.serialno is '流水号';
comment on column ${iol_schema}.icms_group_member_relative.oldmembercustomerid is '原集团成员编号';
comment on column ${iol_schema}.icms_group_member_relative.updateuserid is '更新人';
comment on column ${iol_schema}.icms_group_member_relative.membertype is '成员类型';
comment on column ${iol_schema}.icms_group_member_relative.updatedate is '更新日期';
comment on column ${iol_schema}.icms_group_member_relative.parentmemberid is '父成员编号';
comment on column ${iol_schema}.icms_group_member_relative.oldparentrelationtype is '原父成员关系类型';
comment on column ${iol_schema}.icms_group_member_relative.groupid is '客户编号';
comment on column ${iol_schema}.icms_group_member_relative.oldmembername is '原成员名称';
comment on column ${iol_schema}.icms_group_member_relative.oldmembertype is '原成员类型';
comment on column ${iol_schema}.icms_group_member_relative.inputuserid is '登记人';
comment on column ${iol_schema}.icms_group_member_relative.migtflag is '';
comment on column ${iol_schema}.icms_group_member_relative.inputdate is '登记日期';
comment on column ${iol_schema}.icms_group_member_relative.parentrelationtype is '父成员关系类型';
comment on column ${iol_schema}.icms_group_member_relative.membername is '成员单位名称';
comment on column ${iol_schema}.icms_group_member_relative.reviseflag is '修订标志';
comment on column ${iol_schema}.icms_group_member_relative.membercustomerid is '成员客户编号';
comment on column ${iol_schema}.icms_group_member_relative.membercertid is '成员证件号';
comment on column ${iol_schema}.icms_group_member_relative.inputorgid is '登记单位';
comment on column ${iol_schema}.icms_group_member_relative.remark is '备注';
comment on column ${iol_schema}.icms_group_member_relative.groupcustomertype is '集团客户类型';
comment on column ${iol_schema}.icms_group_member_relative.certid_ent04 is '组织机构代码证(风险预警)';
comment on column ${iol_schema}.icms_group_member_relative.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_group_member_relative.sharevalue is '持股比例';
comment on column ${iol_schema}.icms_group_member_relative.membercerttype is '成员证件类型';
comment on column ${iol_schema}.icms_group_member_relative.oldsharevalue is '原持股比例';
comment on column ${iol_schema}.icms_group_member_relative.start_dt is '开始时间';
comment on column ${iol_schema}.icms_group_member_relative.end_dt is '结束时间';
comment on column ${iol_schema}.icms_group_member_relative.id_mark is '增删标志';
comment on column ${iol_schema}.icms_group_member_relative.etl_timestamp is 'ETL处理时间戳';
