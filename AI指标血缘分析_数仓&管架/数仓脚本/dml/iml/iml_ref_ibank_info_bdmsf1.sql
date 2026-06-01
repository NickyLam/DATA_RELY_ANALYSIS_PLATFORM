/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ref_ibank_info_bdmsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.ref_ibank_info_bdmsf1_tm purge;
drop table ${iml_schema}.ref_ibank_info_bdmsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.ref_ibank_info add partition p_bdmsf1 values ('bdmsf1')(
        subpartition p_bdmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.ref_ibank_info modify partition p_bdmsf1
    add subpartition p_bdmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ref_ibank_info_bdmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_ibank_info partition for ('bdmsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_ibank_info_bdmsf1_tm
compress ${option_switch} for query high
as
select
    ibank_no -- 联行号
    ,lp_id -- 法人编号
    ,bank_cls_id -- 行分类编号
    ,super_prtcpt_bank_no -- 上级参与行号
    ,super_bank_list -- 上级行列表
    ,belong_bank_no -- 所属人行号
    ,prtcpt_type_cd -- 参与类型代码
    ,bank_type_cd -- 行别代码
    ,node_cd -- 节点代码
    ,rg_cd -- 地区代码
    ,status_cd -- 状态代码
    ,bank_fname -- 银行全称
    ,bank_abbr -- 银行简称
    ,phys_addr -- 物理地址
    ,zip_cd -- 邮政编码
    ,tel_num -- 电话号码
    ,elec_addr -- 电子地址
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,cert_bind_cn_region -- 证书绑定CN域
    ,cert_bind_sn_region -- 证书绑定SN域
    ,cert_bind_status -- 证书绑定状态
    ,cert_bind_effect_dt -- 证书绑定生效日期
    ,cert_bind_invalid_dt -- 证书绑定失效日期
    ,final_modif_operr_id -- 最后修改操作员编号
    ,final_update_tm -- 最后更新时间
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_ibank_info
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.ref_ibank_info_bdmsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.ref_ibank_info partition for ('bdmsf1') where 0=1;

-- 2.1 insert data to tm table
-- bdms_bms_ecds_bank_data-
insert into ${iml_schema}.ref_ibank_info_bdmsf1_tm(
    ibank_no -- 联行号
    ,lp_id -- 法人编号
    ,bank_cls_id -- 行分类编号
    ,super_prtcpt_bank_no -- 上级参与行号
    ,super_bank_list -- 上级行列表
    ,belong_bank_no -- 所属人行号
    ,prtcpt_type_cd -- 参与类型代码
    ,bank_type_cd -- 行别代码
    ,node_cd -- 节点代码
    ,rg_cd -- 地区代码
    ,status_cd -- 状态代码
    ,bank_fname -- 银行全称
    ,bank_abbr -- 银行简称
    ,phys_addr -- 物理地址
    ,zip_cd -- 邮政编码
    ,tel_num -- 电话号码
    ,elec_addr -- 电子地址
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,cert_bind_cn_region -- 证书绑定CN域
    ,cert_bind_sn_region -- 证书绑定SN域
    ,cert_bind_status -- 证书绑定状态
    ,cert_bind_effect_dt -- 证书绑定生效日期
    ,cert_bind_invalid_dt -- 证书绑定失效日期
    ,final_modif_operr_id -- 最后修改操作员编号
    ,final_update_tm -- 最后更新时间
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.BANK_NO -- 联行号
    ,'9999' -- 法人编号
    ,' ' -- 行分类编号
    ,P1.SUPER_ACTOR -- 上级参与行号
    ,' ' -- 上级行列表
    ,P1.CATE_PEOPLE_CODE -- 所属人行号
    ,NVL(TRIM(P1.ACTOR_TYPE),'00') -- 参与类型代码
    ,NVL(TRIM(P1.BANK_OTHER_CODE),'-') -- 行别代码
    ,P1.LOCAL_NODE_CODE -- 节点代码
    ,coalesce(TRIM(P1.CITY_CODE),P2.citycd,' ') -- 地区代码
    ,NVL(TRIM(P1.STATUS),'-') -- 状态代码
    ,P1.ACTOR_FULL_CALL -- 银行全称
    ,P1.ACTOR_FOR_SHORT -- 银行简称
    ,P1.ADDRESS -- 物理地址
    ,P1.POST_EDIT -- 邮政编码
    ,P1.PHONE -- 电话号码
    ,P1.EMAIL -- 电子地址
    ,${iml_schema}.DATEFORMAT_MIN(P1.INURE_DATE) -- 生效日期
    ,${iml_schema}.DATEFORMAT_MAX2(P1.LOG_OUT_DATE) -- 失效日期
    ,P1.DN_FIELD -- 证书绑定CN域
    ,P1.SN_FIELD -- 证书绑定SN域
    ,nvl(trim(P1.CERT_BIND_STATUS),'99') -- 证书绑定状态
    ,${iml_schema}.DATEFORMAT_MIN(null) -- 证书绑定生效日期
    ,${iml_schema}.DATEFORMAT_MAX2(null) -- 证书绑定失效日期
    ,' ' -- 最后修改操作员编号
    ,${iml_schema}.TIMEFORMAT_MIN(null) -- 最后更新时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'bdms_bms_ecds_bank_data' -- 源表名称
    ,'bdmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.bdms_bms_ecds_bank_data p1
    left join ${iol_schema}.mpcs_a08tbankinfo p2 on P1.BANK_NO=P2.bkcd
AND  P2.START_DT <= TO_DATE('${batch_date}','YYYYMMDD')
and P2.END_DT > TO_DATE('${batch_date}','YYYYMMDD')
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.ref_ibank_info_bdmsf1_tm 
  	                                group by 
  	                                        ibank_no
  	                                        ,lp_id
  	                               having count(1) > 1);
    if cnt = 0 
      then
        continue;
      else
        raise_application_error(-20001,'primary key is duplication');
    end if;
  end loop;
end;
/

-- 2.2 chage data and update_dt, create_dt, etl_dt
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iml_schema}.ref_ibank_info_bdmsf1_ex(
    ibank_no -- 联行号
    ,lp_id -- 法人编号
    ,bank_cls_id -- 行分类编号
    ,super_prtcpt_bank_no -- 上级参与行号
    ,super_bank_list -- 上级行列表
    ,belong_bank_no -- 所属人行号
    ,prtcpt_type_cd -- 参与类型代码
    ,bank_type_cd -- 行别代码
    ,node_cd -- 节点代码
    ,rg_cd -- 地区代码
    ,status_cd -- 状态代码
    ,bank_fname -- 银行全称
    ,bank_abbr -- 银行简称
    ,phys_addr -- 物理地址
    ,zip_cd -- 邮政编码
    ,tel_num -- 电话号码
    ,elec_addr -- 电子地址
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,cert_bind_cn_region -- 证书绑定CN域
    ,cert_bind_sn_region -- 证书绑定SN域
    ,cert_bind_status -- 证书绑定状态
    ,cert_bind_effect_dt -- 证书绑定生效日期
    ,cert_bind_invalid_dt -- 证书绑定失效日期
    ,final_modif_operr_id -- 最后修改操作员编号
    ,final_update_tm -- 最后更新时间
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.ibank_no, o.ibank_no) as ibank_no -- 联行号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.bank_cls_id, o.bank_cls_id) as bank_cls_id -- 行分类编号
    ,nvl(n.super_prtcpt_bank_no, o.super_prtcpt_bank_no) as super_prtcpt_bank_no -- 上级参与行号
    ,nvl(n.super_bank_list, o.super_bank_list) as super_bank_list -- 上级行列表
    ,nvl(n.belong_bank_no, o.belong_bank_no) as belong_bank_no -- 所属人行号
    ,nvl(n.prtcpt_type_cd, o.prtcpt_type_cd) as prtcpt_type_cd -- 参与类型代码
    ,nvl(n.bank_type_cd, o.bank_type_cd) as bank_type_cd -- 行别代码
    ,nvl(n.node_cd, o.node_cd) as node_cd -- 节点代码
    ,nvl(n.rg_cd, o.rg_cd) as rg_cd -- 地区代码
    ,nvl(n.status_cd, o.status_cd) as status_cd -- 状态代码
    ,nvl(n.bank_fname, o.bank_fname) as bank_fname -- 银行全称
    ,nvl(n.bank_abbr, o.bank_abbr) as bank_abbr -- 银行简称
    ,nvl(n.phys_addr, o.phys_addr) as phys_addr -- 物理地址
    ,nvl(n.zip_cd, o.zip_cd) as zip_cd -- 邮政编码
    ,nvl(n.tel_num, o.tel_num) as tel_num -- 电话号码
    ,nvl(n.elec_addr, o.elec_addr) as elec_addr -- 电子地址
    ,nvl(n.effect_dt, o.effect_dt) as effect_dt -- 生效日期
    ,nvl(n.invalid_dt, o.invalid_dt) as invalid_dt -- 失效日期
    ,nvl(n.cert_bind_cn_region, o.cert_bind_cn_region) as cert_bind_cn_region -- 证书绑定CN域
    ,nvl(n.cert_bind_sn_region, o.cert_bind_sn_region) as cert_bind_sn_region -- 证书绑定SN域
    ,nvl(n.cert_bind_status, o.cert_bind_status) as cert_bind_status -- 证书绑定状态
    ,nvl(n.cert_bind_effect_dt, o.cert_bind_effect_dt) as cert_bind_effect_dt -- 证书绑定生效日期
    ,nvl(n.cert_bind_invalid_dt, o.cert_bind_invalid_dt) as cert_bind_invalid_dt -- 证书绑定失效日期
    ,nvl(n.final_modif_operr_id, o.final_modif_operr_id) as final_modif_operr_id -- 最后修改操作员编号
    ,nvl(n.final_update_tm, o.final_update_tm) as final_update_tm -- 最后更新时间
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.ibank_no is null
                and o.lp_id is null
            ) or (
                o.bank_cls_id <> n.bank_cls_id
                or o.super_prtcpt_bank_no <> n.super_prtcpt_bank_no
                or o.super_bank_list <> n.super_bank_list
                or o.belong_bank_no <> n.belong_bank_no
                or o.prtcpt_type_cd <> n.prtcpt_type_cd
                or o.bank_type_cd <> n.bank_type_cd
                or o.node_cd <> n.node_cd
                or o.rg_cd <> n.rg_cd
                or o.status_cd <> n.status_cd
                or o.bank_fname <> n.bank_fname
                or o.bank_abbr <> n.bank_abbr
                or o.phys_addr <> n.phys_addr
                or o.zip_cd <> n.zip_cd
                or o.tel_num <> n.tel_num
                or o.elec_addr <> n.elec_addr
                or o.effect_dt <> n.effect_dt
                or o.invalid_dt <> n.invalid_dt
                or o.cert_bind_cn_region <> n.cert_bind_cn_region
                or o.cert_bind_sn_region <> n.cert_bind_sn_region
                or o.cert_bind_status <> n.cert_bind_status
                or o.cert_bind_effect_dt <> n.cert_bind_effect_dt
                or o.cert_bind_invalid_dt <> n.cert_bind_invalid_dt
                or o.final_modif_operr_id <> n.final_modif_operr_id
                or o.final_update_tm <> n.final_update_tm
            ) or (
                 case when (
                           n.ibank_no is null
                           and n.lp_id is null
                         )
                      then 'D'
                 else 'I'
                 end
            )<> o.id_mark
        then to_date('${batch_date}', 'yyyymmdd')
        else o.update_dt
     end as update_dt -- 更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt -- ETL处理日期
    ,case when (
                n.ibank_no is null
                and n.lp_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_ibank_info_bdmsf1_tm n
    full join ${iml_schema}.ref_ibank_info_bdmsf1_bk o
        on
            o.ibank_no = n.ibank_no
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.ref_ibank_info truncate partition for ('bdmsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.ref_ibank_info exchange subpartition p_bdmsf1_${batch_date} with table ${iml_schema}.ref_ibank_info_bdmsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.ref_ibank_info drop subpartition p_bdmsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ref_ibank_info to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.ref_ibank_info_bdmsf1_tm purge;
drop table ${iml_schema}.ref_ibank_info_bdmsf1_ex purge;
drop table ${iml_schema}.ref_ibank_info_bdmsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ref_ibank_info', partname => 'p_bdmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);