/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a20tsafeboxdetail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a20tsafeboxdetail
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a20tsafeboxdetail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a20tsafeboxdetail(
    insertdt varchar2(12) -- 登记日期
    ,inserttm varchar2(9) -- 登记时间
    ,operdt varchar2(12) -- 操作日期
    ,opername varchar2(180) -- 操作人
    ,rentboxdate varchar2(12) -- 租箱日期
    ,rentboxenddt varchar2(12) -- 租箱到期日
    ,safebox varchar2(75) -- 保管箱编号
    ,openmode varchar2(45) -- 开箱方式 11：印鉴；12：钥匙；13：密码；14：指纹；15：其他。若复合验证开箱方式为：12+13
    ,opendate varchar2(12) -- 开箱日期
    ,openpsnflag varchar2(3) -- 开箱人公私标识 11：个人；12：单位（指使用人）
    ,openpsnname varchar2(384) -- 开箱人姓名/名称
    ,openpsnidtp varchar2(15) -- 开箱人身份证件/证明文件类型
    ,openpsnidno varchar2(150) -- 开箱人身份证件/证明文件号码
    ,openpsniddt varchar2(45) -- 开箱人身份证件/证明文件有效期
    ,openpsnid varchar2(3) -- 开箱人身份 11：主租人；12：联名人；13：被授权人
    ,brchno varchar2(9) -- 保管箱所在的网点代码
    ,userflag varchar2(3) -- 保管箱实际使用人公私标识 11：个人；12：单位（指使用人）
    ,username varchar2(384) -- 保管箱实际使用人姓名/名称
    ,useridtp varchar2(15) -- 保管箱实际使用人身份证件/证明文件类型
    ,useridno varchar2(150) -- 保管箱实际使用人身份证件/证明文件号码
    ,useriddt varchar2(45) -- 保管箱实际使用人身份证件/证明文件有效期
    ,usercustno varchar2(45) -- 实际使用人客户号
    ,filename varchar2(150) -- 文件名
    ,lineno number(22) -- 行号
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
grant select on ${iol_schema}.mpcs_a20tsafeboxdetail to ${iml_schema};
grant select on ${iol_schema}.mpcs_a20tsafeboxdetail to ${icl_schema};
grant select on ${iol_schema}.mpcs_a20tsafeboxdetail to ${idl_schema};
grant select on ${iol_schema}.mpcs_a20tsafeboxdetail to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a20tsafeboxdetail is '保管箱开关箱明细流水表';
comment on column ${iol_schema}.mpcs_a20tsafeboxdetail.insertdt is '登记日期';
comment on column ${iol_schema}.mpcs_a20tsafeboxdetail.inserttm is '登记时间';
comment on column ${iol_schema}.mpcs_a20tsafeboxdetail.operdt is '操作日期';
comment on column ${iol_schema}.mpcs_a20tsafeboxdetail.opername is '操作人';
comment on column ${iol_schema}.mpcs_a20tsafeboxdetail.rentboxdate is '租箱日期';
comment on column ${iol_schema}.mpcs_a20tsafeboxdetail.rentboxenddt is '租箱到期日';
comment on column ${iol_schema}.mpcs_a20tsafeboxdetail.safebox is '保管箱编号';
comment on column ${iol_schema}.mpcs_a20tsafeboxdetail.openmode is '开箱方式 11：印鉴；12：钥匙；13：密码；14：指纹；15：其他。若复合验证开箱方式为：12+13';
comment on column ${iol_schema}.mpcs_a20tsafeboxdetail.opendate is '开箱日期';
comment on column ${iol_schema}.mpcs_a20tsafeboxdetail.openpsnflag is '开箱人公私标识 11：个人；12：单位（指使用人）';
comment on column ${iol_schema}.mpcs_a20tsafeboxdetail.openpsnname is '开箱人姓名/名称';
comment on column ${iol_schema}.mpcs_a20tsafeboxdetail.openpsnidtp is '开箱人身份证件/证明文件类型';
comment on column ${iol_schema}.mpcs_a20tsafeboxdetail.openpsnidno is '开箱人身份证件/证明文件号码';
comment on column ${iol_schema}.mpcs_a20tsafeboxdetail.openpsniddt is '开箱人身份证件/证明文件有效期';
comment on column ${iol_schema}.mpcs_a20tsafeboxdetail.openpsnid is '开箱人身份 11：主租人；12：联名人；13：被授权人';
comment on column ${iol_schema}.mpcs_a20tsafeboxdetail.brchno is '保管箱所在的网点代码';
comment on column ${iol_schema}.mpcs_a20tsafeboxdetail.userflag is '保管箱实际使用人公私标识 11：个人；12：单位（指使用人）';
comment on column ${iol_schema}.mpcs_a20tsafeboxdetail.username is '保管箱实际使用人姓名/名称';
comment on column ${iol_schema}.mpcs_a20tsafeboxdetail.useridtp is '保管箱实际使用人身份证件/证明文件类型';
comment on column ${iol_schema}.mpcs_a20tsafeboxdetail.useridno is '保管箱实际使用人身份证件/证明文件号码';
comment on column ${iol_schema}.mpcs_a20tsafeboxdetail.useriddt is '保管箱实际使用人身份证件/证明文件有效期';
comment on column ${iol_schema}.mpcs_a20tsafeboxdetail.usercustno is '实际使用人客户号';
comment on column ${iol_schema}.mpcs_a20tsafeboxdetail.filename is '文件名';
comment on column ${iol_schema}.mpcs_a20tsafeboxdetail.lineno is '行号';
comment on column ${iol_schema}.mpcs_a20tsafeboxdetail.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a20tsafeboxdetail.etl_timestamp is 'ETL处理时间戳';
