/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_group_family_member
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_group_family_member
whenever sqlerror continue none;
drop table ${iol_schema}.icms_group_family_member purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_group_family_member(
    memberid varchar2(64) -- 编号
    ,groupid varchar2(64) -- 客户编号
    ,oldmembertype varchar2(36) -- 原成员类型
    ,membercustomerid varchar2(64) -- 集团成员编号
    ,updateorgid varchar2(64) -- 更新机构
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,membername varchar2(160) -- 成员名称
    ,membercertid varchar2(32) -- 成员证件号
    ,membercerttype varchar2(36) -- 成员证件类型
    ,reviseflag varchar2(36) -- 修订标志
    ,inputorgid varchar2(64) -- 登记单位
    ,inputuserid varchar2(64) -- 登记人
    ,inputdate date -- 登记日期
    ,parentrelationtype varchar2(36) -- 父成员关系类型
    ,remark varchar2(1000) -- 备注
    ,parentmemberid varchar2(64) -- 父成员编号
    ,versionseq varchar2(64) -- 版本序号
    ,oldparentrelationtype varchar2(36) -- 原父成员关系类型
    ,status varchar2(36) -- 状态
    ,joinreason varchar2(120) -- 成员加入原因
    ,membertype varchar2(36) -- 成员类型
    ,oldsharevalue number(24,8) -- 原持股比例
    ,updatedate date -- 更新日期
    ,oldmembercustomerid varchar2(64) -- 原集团成员编号
    ,oldmembername varchar2(160) -- 原成员名称
    ,sharevalue number(24,8) -- 持股比例
    ,updateuserid varchar2(64) -- 更新人
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
grant select on ${iol_schema}.icms_group_family_member to ${iml_schema};
grant select on ${iol_schema}.icms_group_family_member to ${icl_schema};
grant select on ${iol_schema}.icms_group_family_member to ${idl_schema};
grant select on ${iol_schema}.icms_group_family_member to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_group_family_member is '集团家谱成员集团家谱成员';
comment on column ${iol_schema}.icms_group_family_member.memberid is '编号';
comment on column ${iol_schema}.icms_group_family_member.groupid is '客户编号';
comment on column ${iol_schema}.icms_group_family_member.oldmembertype is '原成员类型';
comment on column ${iol_schema}.icms_group_family_member.membercustomerid is '集团成员编号';
comment on column ${iol_schema}.icms_group_family_member.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_group_family_member.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_group_family_member.membername is '成员名称';
comment on column ${iol_schema}.icms_group_family_member.membercertid is '成员证件号';
comment on column ${iol_schema}.icms_group_family_member.membercerttype is '成员证件类型';
comment on column ${iol_schema}.icms_group_family_member.reviseflag is '修订标志';
comment on column ${iol_schema}.icms_group_family_member.inputorgid is '登记单位';
comment on column ${iol_schema}.icms_group_family_member.inputuserid is '登记人';
comment on column ${iol_schema}.icms_group_family_member.inputdate is '登记日期';
comment on column ${iol_schema}.icms_group_family_member.parentrelationtype is '父成员关系类型';
comment on column ${iol_schema}.icms_group_family_member.remark is '备注';
comment on column ${iol_schema}.icms_group_family_member.parentmemberid is '父成员编号';
comment on column ${iol_schema}.icms_group_family_member.versionseq is '版本序号';
comment on column ${iol_schema}.icms_group_family_member.oldparentrelationtype is '原父成员关系类型';
comment on column ${iol_schema}.icms_group_family_member.status is '状态';
comment on column ${iol_schema}.icms_group_family_member.joinreason is '成员加入原因';
comment on column ${iol_schema}.icms_group_family_member.membertype is '成员类型';
comment on column ${iol_schema}.icms_group_family_member.oldsharevalue is '原持股比例';
comment on column ${iol_schema}.icms_group_family_member.updatedate is '更新日期';
comment on column ${iol_schema}.icms_group_family_member.oldmembercustomerid is '原集团成员编号';
comment on column ${iol_schema}.icms_group_family_member.oldmembername is '原成员名称';
comment on column ${iol_schema}.icms_group_family_member.sharevalue is '持股比例';
comment on column ${iol_schema}.icms_group_family_member.updateuserid is '更新人';
comment on column ${iol_schema}.icms_group_family_member.start_dt is '开始时间';
comment on column ${iol_schema}.icms_group_family_member.end_dt is '结束时间';
comment on column ${iol_schema}.icms_group_family_member.id_mark is '增删标志';
comment on column ${iol_schema}.icms_group_family_member.etl_timestamp is 'ETL处理时间戳';
