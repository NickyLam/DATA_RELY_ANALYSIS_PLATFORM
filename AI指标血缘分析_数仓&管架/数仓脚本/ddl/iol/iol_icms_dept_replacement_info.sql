/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_dept_replacement_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_dept_replacement_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_dept_replacement_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_dept_replacement_info(
    serialno varchar2(64) -- 流水号
    ,putoutserialno varchar2(64) -- 出账流水号
    ,deptorname varchar2(200) -- 被置换贷款借款人名称
    ,bankname varchar2(384) -- 被置换贷款发放行名称
    ,depttype varchar2(2) -- 被置换债务类型
    ,certtype varchar2(4) -- 被置换债务债权人证件类型
    ,certid varchar2(60) -- 被置换债务债权人证件代码
    ,platformloan varchar2(1) -- 是否置换地方政府融资平台债务
    ,depttoken varchar2(200) -- 被置换债务凭证编码
    ,currency varchar2(3) -- 被置换债务币种
    ,rmbamount number(24,6) -- 被置换债务金额折人民币
    ,executerate number(24,8) -- 被置换债务利率水平
    ,inputuserid varchar2(64) -- 登记人
    ,inputorgid varchar2(64) -- 登记机构
    ,inputdate date -- 登记日期
    ,updateuserid varchar2(64) -- 更新人
    ,updateorgid varchar2(64) -- 更新机构
    ,updatedate date -- 更新日期
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
grant select on ${iol_schema}.icms_dept_replacement_info to ${iml_schema};
grant select on ${iol_schema}.icms_dept_replacement_info to ${icl_schema};
grant select on ${iol_schema}.icms_dept_replacement_info to ${idl_schema};
grant select on ${iol_schema}.icms_dept_replacement_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_dept_replacement_info is '非同业单位贷款置换旧债表';
comment on column ${iol_schema}.icms_dept_replacement_info.serialno is '流水号';
comment on column ${iol_schema}.icms_dept_replacement_info.putoutserialno is '出账流水号';
comment on column ${iol_schema}.icms_dept_replacement_info.deptorname is '被置换贷款借款人名称';
comment on column ${iol_schema}.icms_dept_replacement_info.bankname is '被置换贷款发放行名称';
comment on column ${iol_schema}.icms_dept_replacement_info.depttype is '被置换债务类型';
comment on column ${iol_schema}.icms_dept_replacement_info.certtype is '被置换债务债权人证件类型';
comment on column ${iol_schema}.icms_dept_replacement_info.certid is '被置换债务债权人证件代码';
comment on column ${iol_schema}.icms_dept_replacement_info.platformloan is '是否置换地方政府融资平台债务';
comment on column ${iol_schema}.icms_dept_replacement_info.depttoken is '被置换债务凭证编码';
comment on column ${iol_schema}.icms_dept_replacement_info.currency is '被置换债务币种';
comment on column ${iol_schema}.icms_dept_replacement_info.rmbamount is '被置换债务金额折人民币';
comment on column ${iol_schema}.icms_dept_replacement_info.executerate is '被置换债务利率水平';
comment on column ${iol_schema}.icms_dept_replacement_info.inputuserid is '登记人';
comment on column ${iol_schema}.icms_dept_replacement_info.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_dept_replacement_info.inputdate is '登记日期';
comment on column ${iol_schema}.icms_dept_replacement_info.updateuserid is '更新人';
comment on column ${iol_schema}.icms_dept_replacement_info.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_dept_replacement_info.updatedate is '更新日期';
comment on column ${iol_schema}.icms_dept_replacement_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_dept_replacement_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_dept_replacement_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_dept_replacement_info.etl_timestamp is 'ETL处理时间戳';
