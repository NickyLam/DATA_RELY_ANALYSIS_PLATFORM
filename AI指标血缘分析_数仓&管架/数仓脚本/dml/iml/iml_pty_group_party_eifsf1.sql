/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_pty_group_party_eifsf1
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
drop table ${iml_schema}.pty_group_party_eifsf1_tm purge;
drop table ${iml_schema}.pty_group_party_eifsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.pty_group_party add partition p_eifsf1 values ('eifsf1')(
        subpartition p_eifsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.pty_group_party modify partition p_eifsf1
    add subpartition p_eifsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.pty_group_party_eifsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_group_party partition for ('eifsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_group_party_eifsf1_tm
compress ${option_switch} for query high
as
select
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,group_name -- 集团名称
    ,group_abbr -- 集团简称
    ,group_en_name -- 集团英文名称
    ,cty_rg_cd -- 国家和地区代码
    ,work_land_dist_cd -- 办公地行政区划代码
    ,dom_work_addr -- 国内办公地址
    ,ibank_group_flg -- 同业集团标志
    ,mem_cnt -- 集团成员数
    ,group_risk_warn_sgn_cd -- 集团风险预警信号代码
    ,group_status_cd -- 集团状态代码
    ,parent_corp_cust_id -- 母公司客户编号
    ,cust_mgr_name -- 客户经理姓名
    ,cust_mgr_id -- 客户经理编号
    ,tax_resdnt_idti_cd -- 税收居民身份代码
    ,tax_org_cate_cd -- 税收机构类别代码
    ,group_cust_type_cd -- 集团客户类型代码
    ,bk_idtfy_group_cust_flg -- 认定集团客户机构类型代码
    ,actl_ctrler_name -- 实际控制人名称
    ,actl_ctrler_cert_no -- 实际控制人证件号码
    ,actl_ctrler_cert_type_cd -- 实际控制人证件类型代码
    ,actl_ctrler_cty_cd -- 实际控制人国家代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_group_party
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.pty_group_party_eifsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.pty_group_party partition for ('eifsf1') where 0=1;

-- 2.1 insert data to tm table
-- eifs_t01_corp_group_info-1
insert into ${iml_schema}.pty_group_party_eifsf1_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,group_name -- 集团名称
    ,group_abbr -- 集团简称
    ,group_en_name -- 集团英文名称
    ,cty_rg_cd -- 国家和地区代码
    ,work_land_dist_cd -- 办公地行政区划代码
    ,dom_work_addr -- 国内办公地址
    ,ibank_group_flg -- 同业集团标志
    ,mem_cnt -- 集团成员数
    ,group_risk_warn_sgn_cd -- 集团风险预警信号代码
    ,group_status_cd -- 集团状态代码
    ,parent_corp_cust_id -- 母公司客户编号
    ,cust_mgr_name -- 客户经理姓名
    ,cust_mgr_id -- 客户经理编号
    ,tax_resdnt_idti_cd -- 税收居民身份代码
    ,tax_org_cate_cd -- 税收机构类别代码
    ,group_cust_type_cd -- 集团客户类型代码
    ,bk_idtfy_group_cust_flg -- 认定集团客户机构类型代码
    ,actl_ctrler_name -- 实际控制人名称
    ,actl_ctrler_cert_no -- 实际控制人证件号码
    ,actl_ctrler_cert_type_cd -- 实际控制人证件类型代码
    ,actl_ctrler_cty_cd -- 实际控制人国家代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.GROUP_NUM -- 当事人编号
    ,'9999' -- 法人编号
    ,P1.GROUP_NAME -- 集团名称
    ,P1.GROUP_SHORT_NAME -- 集团简称
    ,P1.GROUP_EN_NAME -- 集团英文名称
    ,NVL(TRIM(P1.PHYS_ADDR_CTY_ZONE_CD),'XXX') -- 国家和地区代码
    ,NVL(TRIM(P1.GROUP_WORK_ADDR_DIST_CD),'000000') -- 办公地行政区划代码
    ,P1.GROUP_DOM_WORK_ADDR -- 国内办公地址
    ,P1.TRADE_GROUP_IND -- 同业集团标志
    ,P1.GROUP_MEM_CNT -- 集团成员数
    ,NVL(TRIM(P1.GROUP_RISK_WARN_INFO_CD),'000') -- 集团风险预警信号代码
    ,nvl(trim(P1.GROUP_STATUS),'-') -- 集团状态代码
    ,P1.PRNT_CUST_NO -- 母公司客户编号
    ,P1.CUST_MGR_NAME -- 客户经理姓名
    ,P1.CUST_MGR_NUM -- 客户经理编号
    ,NVL(TRIM(P1.TAX_PAY_CTZN_IDNT),'5') -- 税收居民身份代码
    ,NVL(TRIM(P1.TAX_ORG_TYPE),'-') -- 税收机构类别代码
    ,NVL(TRIM(P1.GRP_TYP),'-') -- 集团客户类型代码
    ,decode(trim(P1.BASE_GROUP_CUST_NO),'','-','1','01','2','02',P1.BASE_GROUP_CUST_NO) -- 认定集团客户机构类型代码
    ,P1.ACTL_CTRL_NAME -- 实际控制人名称
    ,P1.ACTL_CTRL_CERT_NUM -- 实际控制人证件号码
    ,nvl(trim(P1.ACTL_CTRL_IDEN_TYP),'0000') -- 实际控制人证件类型代码
    ,NVL(TRIM(P1.ACTL_CTRL_NATION_CD),'XXX') -- 实际控制人国家代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'eifs_t01_corp_group_info' -- 源表名称
    ,'eifsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
  from ${iol_schema}.eifs_t01_corp_group_info p1
  left join ${iol_schema}.eifs_t00_party_pub_info p2
    on p1.group_num = p2.cust_num
   and p2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and p2.end_dt > to_date('${batch_date}', 'yyyymmdd')
 where p1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and p1.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and p2.party_id is null

;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.pty_group_party_eifsf1_tm 
  	                                group by 
  	                                        party_id
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
insert /*+ append */ into ${iml_schema}.pty_group_party_eifsf1_ex(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,group_name -- 集团名称
    ,group_abbr -- 集团简称
    ,group_en_name -- 集团英文名称
    ,cty_rg_cd -- 国家和地区代码
    ,work_land_dist_cd -- 办公地行政区划代码
    ,dom_work_addr -- 国内办公地址
    ,ibank_group_flg -- 同业集团标志
    ,mem_cnt -- 集团成员数
    ,group_risk_warn_sgn_cd -- 集团风险预警信号代码
    ,group_status_cd -- 集团状态代码
    ,parent_corp_cust_id -- 母公司客户编号
    ,cust_mgr_name -- 客户经理姓名
    ,cust_mgr_id -- 客户经理编号
    ,tax_resdnt_idti_cd -- 税收居民身份代码
    ,tax_org_cate_cd -- 税收机构类别代码
    ,group_cust_type_cd -- 集团客户类型代码
    ,bk_idtfy_group_cust_flg -- 认定集团客户机构类型代码
    ,actl_ctrler_name -- 实际控制人名称
    ,actl_ctrler_cert_no -- 实际控制人证件号码
    ,actl_ctrler_cert_type_cd -- 实际控制人证件类型代码
    ,actl_ctrler_cty_cd -- 实际控制人国家代码
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.party_id, o.party_id) as party_id -- 当事人编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.group_name, o.group_name) as group_name -- 集团名称
    ,nvl(n.group_abbr, o.group_abbr) as group_abbr -- 集团简称
    ,nvl(n.group_en_name, o.group_en_name) as group_en_name -- 集团英文名称
    ,nvl(n.cty_rg_cd, o.cty_rg_cd) as cty_rg_cd -- 国家和地区代码
    ,nvl(n.work_land_dist_cd, o.work_land_dist_cd) as work_land_dist_cd -- 办公地行政区划代码
    ,nvl(n.dom_work_addr, o.dom_work_addr) as dom_work_addr -- 国内办公地址
    ,nvl(n.ibank_group_flg, o.ibank_group_flg) as ibank_group_flg -- 同业集团标志
    ,nvl(n.mem_cnt, o.mem_cnt) as mem_cnt -- 集团成员数
    ,nvl(n.group_risk_warn_sgn_cd, o.group_risk_warn_sgn_cd) as group_risk_warn_sgn_cd -- 集团风险预警信号代码
    ,nvl(n.group_status_cd, o.group_status_cd) as group_status_cd -- 集团状态代码
    ,nvl(n.parent_corp_cust_id, o.parent_corp_cust_id) as parent_corp_cust_id -- 母公司客户编号
    ,nvl(n.cust_mgr_name, o.cust_mgr_name) as cust_mgr_name -- 客户经理姓名
    ,nvl(n.cust_mgr_id, o.cust_mgr_id) as cust_mgr_id -- 客户经理编号
    ,nvl(n.tax_resdnt_idti_cd, o.tax_resdnt_idti_cd) as tax_resdnt_idti_cd -- 税收居民身份代码
    ,nvl(n.tax_org_cate_cd, o.tax_org_cate_cd) as tax_org_cate_cd -- 税收机构类别代码
    ,nvl(n.group_cust_type_cd, o.group_cust_type_cd) as group_cust_type_cd -- 集团客户类型代码
    ,nvl(n.bk_idtfy_group_cust_flg, o.bk_idtfy_group_cust_flg) as bk_idtfy_group_cust_flg -- 认定集团客户机构类型代码
    ,nvl(n.actl_ctrler_name, o.actl_ctrler_name) as actl_ctrler_name -- 实际控制人名称
    ,nvl(n.actl_ctrler_cert_no, o.actl_ctrler_cert_no) as actl_ctrler_cert_no -- 实际控制人证件号码
    ,nvl(n.actl_ctrler_cert_type_cd, o.actl_ctrler_cert_type_cd) as actl_ctrler_cert_type_cd -- 实际控制人证件类型代码
    ,nvl(n.actl_ctrler_cty_cd, o.actl_ctrler_cty_cd) as actl_ctrler_cty_cd -- 实际控制人国家代码
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.party_id is null
                and o.lp_id is null
            ) or (
                o.group_name <> n.group_name
                or o.group_abbr <> n.group_abbr
                or o.group_en_name <> n.group_en_name
                or o.cty_rg_cd <> n.cty_rg_cd
                or o.work_land_dist_cd <> n.work_land_dist_cd
                or o.dom_work_addr <> n.dom_work_addr
                or o.ibank_group_flg <> n.ibank_group_flg
                or o.mem_cnt <> n.mem_cnt
                or o.group_risk_warn_sgn_cd <> n.group_risk_warn_sgn_cd
                or o.group_status_cd <> n.group_status_cd
                or o.parent_corp_cust_id <> n.parent_corp_cust_id
                or o.cust_mgr_name <> n.cust_mgr_name
                or o.cust_mgr_id <> n.cust_mgr_id
                or o.tax_resdnt_idti_cd <> n.tax_resdnt_idti_cd
                or o.tax_org_cate_cd <> n.tax_org_cate_cd
                or o.group_cust_type_cd <> n.group_cust_type_cd
                or o.bk_idtfy_group_cust_flg <> n.bk_idtfy_group_cust_flg
                or o.actl_ctrler_name <> n.actl_ctrler_name
                or o.actl_ctrler_cert_no <> n.actl_ctrler_cert_no
                or o.actl_ctrler_cert_type_cd <> n.actl_ctrler_cert_type_cd
                or o.actl_ctrler_cty_cd <> n.actl_ctrler_cty_cd
            ) or (
                 case when (
                           n.party_id is null
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
                n.party_id is null
                and n.lp_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_group_party_eifsf1_tm n
    full join ${iml_schema}.pty_group_party_eifsf1_bk o
        on
            o.party_id = n.party_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.pty_group_party truncate partition for ('eifsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.pty_group_party exchange subpartition p_eifsf1_${batch_date} with table ${iml_schema}.pty_group_party_eifsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.pty_group_party drop subpartition p_eifsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.pty_group_party to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.pty_group_party_eifsf1_tm purge;
drop table ${iml_schema}.pty_group_party_eifsf1_ex purge;
drop table ${iml_schema}.pty_group_party_eifsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'pty_group_party', partname => 'p_eifsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);