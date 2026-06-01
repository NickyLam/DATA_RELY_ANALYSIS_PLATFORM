/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_aml_bdms_union_bank
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 4;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.aml_bdms_union_bank drop partition p_${last_date};
alter table ${idl_schema}.aml_bdms_union_bank drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.aml_bdms_union_bank add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.aml_bdms_union_bank partition for (to_date('${batch_date}','yyyymmdd')) (
    id  -- ID
    ,ubank_no  -- 行号
    ,ctgy  -- 参与者类型
    ,clss  -- 行别代码
    ,ubank_cat_id  -- 行分类ID
    ,drct  -- 上级参与者
    ,ndcd  -- 节点代码
    ,sprr_lst  -- 上级行列表
    ,pbcbk  -- 所属人行
    ,ubank_city  -- 城市代码
    ,ubank_name  -- 行名全称
    ,shrt_nm  -- 简称
    ,ubank_address  -- 地址
    ,ubank_zip  -- 邮编
    ,ubank_tel  -- 电话
    ,email  -- EMAIL地址
    ,fctv_dt  -- 生效日
    ,upd_time  -- 更新时间
    ,term_nb  -- 记录更新期数
    ,proc_status  -- 处理状态
    ,rmrk  -- 备注
    ,xpry_dt  -- 失效日
    ,status  -- 状态
    ,ubank_linkman  -- 联系人(人行无此字段)
    ,cert_info_cn  -- 证书绑定CN域
    ,cert_info_sn  -- 证书绑定SN域
    ,cert_bind_status  -- 证书绑定状态
    ,cert_valide_date  -- 证书绑定生效日
    ,cert_invalide_date  -- 证书绑定失效日
    ,last_upd_oprid  -- 最后修改操作员号
    ,last_upd_txn_id  -- 最后修改交易ID
    ,last_upd_ts  -- 最后修改时间
    ,start_dt  -- 开始时间
    ,end_dt  -- 结束时间
    ,id_mark  -- 删除标志
    ,etl_dt  -- ETL处理日期
    ,etl_timestamp  -- ETL处理时间戳
)
select
    t1.id  -- ID
    ,replace(replace(t1.ubank_no,chr(13),''),chr(10),'')  -- 行号
    ,replace(replace(t1.ctgy,chr(13),''),chr(10),'')  -- 参与者类型
    ,replace(replace(t1.clss,chr(13),''),chr(10),'')  -- 行别代码
    ,t1.ubank_cat_id  -- 行分类ID
    ,replace(replace(t1.drct,chr(13),''),chr(10),'')  -- 上级参与者
    ,replace(replace(t1.ndcd,chr(13),''),chr(10),'')  -- 节点代码
    ,replace(replace(t1.sprr_lst,chr(13),''),chr(10),'')  -- 上级行列表
    ,replace(replace(t1.pbcbk,chr(13),''),chr(10),'')  -- 所属人行
    ,replace(replace(t1.ubank_city,chr(13),''),chr(10),'')  -- 城市代码
    ,replace(replace(t1.ubank_name,chr(13),''),chr(10),'')  -- 行名全称
    ,replace(replace(t1.shrt_nm,chr(13),''),chr(10),'')  -- 简称
    ,replace(replace(t1.ubank_address,chr(13),''),chr(10),'')  -- 地址
    ,replace(replace(t1.ubank_zip,chr(13),''),chr(10),'')  -- 邮编
    ,replace(replace(t1.ubank_tel,chr(13),''),chr(10),'')  -- 电话
    ,replace(replace(t1.email,chr(13),''),chr(10),'')  -- EMAIL地址
    ,replace(replace(t1.fctv_dt,chr(13),''),chr(10),'')  -- 生效日
    ,replace(replace(t1.upd_time,chr(13),''),chr(10),'')  -- 更新时间
    ,replace(replace(t1.term_nb,chr(13),''),chr(10),'')  -- 记录更新期数
    ,replace(replace(t1.proc_status,chr(13),''),chr(10),'')  -- 处理状态
    ,replace(replace(t1.rmrk,chr(13),''),chr(10),'')  -- 备注
    ,replace(replace(t1.xpry_dt,chr(13),''),chr(10),'')  -- 失效日
    ,replace(replace(t1.status,chr(13),''),chr(10),'')  -- 状态
    ,replace(replace(t1.ubank_linkman,chr(13),''),chr(10),'')  -- 联系人(人行无此字段)
    ,replace(replace(t1.cert_info_cn,chr(13),''),chr(10),'')  -- 证书绑定CN域
    ,replace(replace(t1.cert_info_sn,chr(13),''),chr(10),'')  -- 证书绑定SN域
    ,replace(replace(t1.cert_bind_status,chr(13),''),chr(10),'')  -- 证书绑定状态
    ,replace(replace(t1.cert_valide_date,chr(13),''),chr(10),'')  -- 证书绑定生效日
    ,replace(replace(t1.cert_invalide_date,chr(13),''),chr(10),'')  -- 证书绑定失效日
    ,t1.last_upd_oprid  -- 最后修改操作员号
    ,replace(replace(t1.last_upd_txn_id,chr(13),''),chr(10),'')  -- 最后修改交易ID
    ,replace(replace(t1.last_upd_ts,chr(13),''),chr(10),'')  -- 最后修改时间
    ,t1.start_dt  -- 开始时间
    ,t1.end_dt  -- 结束时间
    ,replace(replace(t1.id_mark,chr(13),''),chr(10),'')  -- 删除标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt  -- ETL处理日期
    ,t1.etl_timestamp  -- ETL处理时间戳
from ${iol_schema}.bdms_union_bank t1    --联行表
where t1.start_dt <=to_date('${batch_date}','yyyymmdd') and t1.end_dt >to_date('${batch_date}','yyyymmdd') and t1.id_mark <> 'D' ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'aml_bdms_union_bank',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);