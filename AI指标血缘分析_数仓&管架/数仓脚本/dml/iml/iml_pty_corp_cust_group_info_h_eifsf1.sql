/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_pty_corp_cust_group_info_h_eifsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create backup table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.pty_corp_cust_group_info_h add partition p_eifsf1 values ('eifsf1')(
        subpartition p_eifsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_eifsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.pty_corp_cust_group_info_h_eifsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_corp_cust_group_info_h partition for ('eifsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.pty_corp_cust_group_info_h_eifsf1_tm purge;
drop table ${iml_schema}.pty_corp_cust_group_info_h_eifsf1_op purge;
drop table ${iml_schema}.pty_corp_cust_group_info_h_eifsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_corp_cust_group_info_h_eifsf1_tm nologging
compress ${option_switch} for query high
as select
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,belong_group_id -- 所属集团编号
    ,data_src_cd -- 数据来源代码
    ,belong_group_name -- 所属集团名称
    ,belong_group_orgnz_cd -- 所属集团组织机构代码
    ,belong_group_loan_card_no -- 所属集团贷款卡号
    ,belong_group_rgst_cty_rg_cd -- 所属集团注册国家地区代码
    ,belong_group_site_cd -- 所属集团所在地代码
    ,belong_group_rgst_addr -- 所属集团注册地址
    ,group_core_mem_flg -- 集团核心成员标志
    ,belong_group_dom_work_addr -- 所属集团国内办公地址
    ,mem_type_cd -- 成员类型代码
    ,parent_corp_flg -- 母公司标志
    ,mem_status_cd -- 成员状态代码
    ,use_family_edit_num -- 当前使用的家谱版本号
    ,matn_family_edit_num -- 当前维护的家谱版本号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_corp_cust_group_info_h partition for ('eifsf1')
where 0=1
;

create table ${iml_schema}.pty_corp_cust_group_info_h_eifsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_corp_cust_group_info_h partition for ('eifsf1') where 0=1;

create table ${iml_schema}.pty_corp_cust_group_info_h_eifsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_corp_cust_group_info_h partition for ('eifsf1') where 0=1;

-- 3.1 get new data into table
-- eifs_t01_corp_group_members-1
insert into ${iml_schema}.pty_corp_cust_group_info_h_eifsf1_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,belong_group_id -- 所属集团编号
    ,data_src_cd -- 数据来源代码
    ,belong_group_name -- 所属集团名称
    ,belong_group_orgnz_cd -- 所属集团组织机构代码
    ,belong_group_loan_card_no -- 所属集团贷款卡号
    ,belong_group_rgst_cty_rg_cd -- 所属集团注册国家地区代码
    ,belong_group_site_cd -- 所属集团所在地代码
    ,belong_group_rgst_addr -- 所属集团注册地址
    ,group_core_mem_flg -- 集团核心成员标志
    ,belong_group_dom_work_addr -- 所属集团国内办公地址
    ,mem_type_cd -- 成员类型代码
    ,parent_corp_flg -- 母公司标志
    ,mem_status_cd -- 成员状态代码
    ,use_family_edit_num -- 当前使用的家谱版本号
    ,matn_family_edit_num -- 当前维护的家谱版本号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.MEM_CUST_NUM -- 当事人编号
    ,'9999' -- 法人编号
    ,P1.BELONG_GROUP_NUM -- 所属集团编号
    ,'EIFS' -- 数据来源代码
    ,NVL(P2.GROUP_NAME,' ') -- 所属集团名称
    ,NVL(P6.CERT_NUM,' ') -- 所属集团组织机构代码
    ,NVL(P4.LOAN_CARD_NUM,' ') -- 所属集团贷款卡号
    ,NVL(TRIM(P2.PHYS_ADDR_CTY_ZONE_CD),'XXX')  -- 所属集团注册国家地区代码
    ,NVL(TRIM(P2.GROUP_WORK_ADDR_DIST_CD),'000000')  -- 所属集团所在地代码
    ,NVL(P5.PHYS_ADDR_TYPE_CD,' ') -- 所属集团注册地址
    ,CASE WHEN P1.MEM_TYPE_CD='1' THEN '1' ELSE '0' END -- 集团核心成员标志
    ,NVL(P2.GROUP_DOM_WORK_ADDR,' ') -- 所属集团国内办公地址
    ,nvl(trim(P1.MEM_TYPE_CD),'-') -- 成员类型代码
    ,CASE WHEN P1.GRCORP_IND='1' THEN '1' WHEN P1.GRCORP_IND='0' THEN '0' ELSE '-' END -- 母公司标志
    ,nvl(trim(P1.MEMBER_STATUS),'-')  -- 成员状态代码
    ,' ' -- 当前使用的家谱版本号
    ,' ' -- 当前维护的家谱版本号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'eifs_t01_corp_group_members' -- 源表名称
    ,'eifsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
  from ${iol_schema}.eifs_t01_corp_group_members p1
  left join ${iol_schema}.eifs_t01_corp_group_info p2
    on p1.belong_group_num = p2.group_num
   and p2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and p2.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iol_schema}.eifs_t00_corp_cust_no_ref p3
    on p2.prnt_cust_no = p3.cust_num
   and p3.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and p3.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join (select t1.*,
                    row_number() over(partition by party_id, cert_type_cd order by t1.updated_ts desc) as rid
               from ${iol_schema}.eifs_t00_corp_cust_cert_ref t1
              where t1.cert_type_cd = '2020'
                and to_date(to_char(t1.updated_ts, 'yyyymmdd'), 'yyyymmdd') >
                    to_date('${batch_date}', 'yyyymmdd')
                and t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')) p6
    on p3.party_id = p6.party_id
   and p6.rid = 1
  left join (select t.*,
                    row_number() over(partition by party_id order by updated_ts desc) rn
               from ${iol_schema}.eifs_t01_corp_cust_ext_info t
              where t.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                and t.end_dt > to_date('${batch_date}', 'yyyymmdd')) p4
    on p3.party_id = p4.party_id
   and p4.rn = 1
  left join (select t1.*,
                    row_number() over(partition by party_id, phys_addr_type_cd order by updated_ts desc) as rid
               from ${iol_schema}.eifs_t03_corp_addr_info t1
              where to_date(to_char(t1.updated_ts, 'yyyymmdd'), 'yyyymmdd') >
                    to_date('${batch_date}', 'yyyymmdd')
                and t1.phys_addr_type_cd = '05'
                and t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')) p5
    on p3.party_id = p5.party_id
   and p5.rid = 1
 inner join (select t1.*,
                    row_number() over(partition by mem_cust_num, belong_group_num order by member_status, updated_ts desc) as rn
               from ${iol_schema}.eifs_t01_corp_group_members t1
              where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')) p7
    on p1.party_id = p7.party_id
   and p1.member_id = p7.member_id
   and p7.rn = 1
 where p1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and p1.end_dt > to_date('${batch_date}', 'yyyymmdd')
;
commit;


-- eifs_t01_corp_rel_corp_info-1
insert into ${iml_schema}.pty_corp_cust_group_info_h_eifsf1_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,belong_group_id -- 所属集团编号
    ,data_src_cd -- 数据来源代码
    ,belong_group_name -- 所属集团名称
    ,belong_group_orgnz_cd -- 所属集团组织机构代码
    ,belong_group_loan_card_no -- 所属集团贷款卡号
    ,belong_group_rgst_cty_rg_cd -- 所属集团注册国家地区代码
    ,belong_group_site_cd -- 所属集团所在地代码
    ,belong_group_rgst_addr -- 所属集团注册地址
    ,group_core_mem_flg -- 集团核心成员标志
    ,belong_group_dom_work_addr -- 所属集团国内办公地址
    ,mem_type_cd -- 成员类型代码
    ,parent_corp_flg -- 母公司标志
    ,mem_status_cd -- 成员状态代码
    ,use_family_edit_num -- 当前使用的家谱版本号
    ,matn_family_edit_num -- 当前维护的家谱版本号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    distinct P1.rela_num -- 当事人编号
    ,'9999' -- 法人编号
    ,P2.cust_num -- 所属集团编号
    ,'EIFS' -- 数据来源代码
    ,P3.cust_name -- 所属集团名称
    ,P4.Cert_Num -- 所属集团组织机构代码
    ,P4.LOAN_CARD_NUM -- 所属集团贷款卡号
    ,'XXX' -- 所属集团注册国家地区代码
    ,NVL(P5.REG_AREA_CODE,'XXX') -- 所属集团所在地代码
    ,' ' -- 所属集团注册地址
    ,' ' -- 集团核心成员标志
    ,' ' -- 所属集团国内办公地址
    ,'-' -- 成员类型代码
    ,'-' -- 母公司标志
    ,'-' -- 成员状态代码
    ,' ' -- 当前使用的家谱版本号
    ,' ' -- 当前维护的家谱版本号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'eifs_t01_corp_rel_corp_info' -- 源表名称
    ,'eifsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
  from ${iol_schema}.eifs_t01_corp_rel_corp_info p1
 inner join ${iol_schema}.eifs_t00_corp_cust_no_ref p2
    on p1.party_id = p2.party_id
   and p2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and p2.end_dt > to_date('${batch_date}', 'yyyymmdd')
 inner join ${iol_schema}.eifs_t01_corp_cust_info p3
    on p1.party_id = p3.party_id
   and p3.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and p3.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join (select y.cust_num, z.cert_num, zz.loan_card_num
               from ${iol_schema}.eifs_t00_corp_cust_no_ref y
               left join ${iol_schema}.eifs_t00_corp_cust_cert_ref z
                 on (y.party_id = z.party_id and z.cert_type_cd = '2020' and
                    z.start_dt <= to_date('${batch_date}', 'yyyymmdd') and
                    z.end_dt > to_date('${batch_date}', 'yyyymmdd'))
               left join (select t.*,
                                row_number() over(partition by party_id order by updated_ts desc) rn
                           from ${iol_schema}.eifs_t01_corp_cust_ext_info t
                          where t.start_dt <=
                                to_date('${batch_date}', 'yyyymmdd')
                            and t.end_dt >
                                to_date('${batch_date}', 'yyyymmdd')) zz
                 on y.party_id = zz.party_id
                and zz.rn = 1
              where y.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                and y.end_dt > to_date('${batch_date}', 'yyyymmdd')) p4
    on p2.cust_num = p4.cust_num
  left join ${iol_schema}.eifs_t01_corp_cust_info p5
    on p1.party_id = p5.party_id
   and p5.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and p5.end_dt > to_date('${batch_date}', 'yyyymmdd')
 where p1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and p1.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and p2.updated_ts =
       to_timestamp('9999-12-31 00:00:00', 'YYYY-MM-DD HH24:MI:SS')
   and p1.updated_ts =
       to_timestamp('9999-12-31 00:00:00', 'YYYY-MM-DD HH24:MI:SS')
   and p1.rela_cust_rela_cd = '10100'

;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.pty_corp_cust_group_info_h_eifsf1_tm 
  	                                group by 
  	                                        party_id
  	                                        ,lp_id
  	                                        ,belong_group_id
  	                                        ,data_src_cd
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


-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.pty_corp_cust_group_info_h_eifsf1_cl(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,belong_group_id -- 所属集团编号
    ,data_src_cd -- 数据来源代码
    ,belong_group_name -- 所属集团名称
    ,belong_group_orgnz_cd -- 所属集团组织机构代码
    ,belong_group_loan_card_no -- 所属集团贷款卡号
    ,belong_group_rgst_cty_rg_cd -- 所属集团注册国家地区代码
    ,belong_group_site_cd -- 所属集团所在地代码
    ,belong_group_rgst_addr -- 所属集团注册地址
    ,group_core_mem_flg -- 集团核心成员标志
    ,belong_group_dom_work_addr -- 所属集团国内办公地址
    ,mem_type_cd -- 成员类型代码
    ,parent_corp_flg -- 母公司标志
    ,mem_status_cd -- 成员状态代码
    ,use_family_edit_num -- 当前使用的家谱版本号
    ,matn_family_edit_num -- 当前维护的家谱版本号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_corp_cust_group_info_h_eifsf1_op(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,belong_group_id -- 所属集团编号
    ,data_src_cd -- 数据来源代码
    ,belong_group_name -- 所属集团名称
    ,belong_group_orgnz_cd -- 所属集团组织机构代码
    ,belong_group_loan_card_no -- 所属集团贷款卡号
    ,belong_group_rgst_cty_rg_cd -- 所属集团注册国家地区代码
    ,belong_group_site_cd -- 所属集团所在地代码
    ,belong_group_rgst_addr -- 所属集团注册地址
    ,group_core_mem_flg -- 集团核心成员标志
    ,belong_group_dom_work_addr -- 所属集团国内办公地址
    ,mem_type_cd -- 成员类型代码
    ,parent_corp_flg -- 母公司标志
    ,mem_status_cd -- 成员状态代码
    ,use_family_edit_num -- 当前使用的家谱版本号
    ,matn_family_edit_num -- 当前维护的家谱版本号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.party_id, o.party_id) as party_id -- 当事人编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.belong_group_id, o.belong_group_id) as belong_group_id -- 所属集团编号
    ,nvl(n.data_src_cd, o.data_src_cd) as data_src_cd -- 数据来源代码
    ,nvl(n.belong_group_name, o.belong_group_name) as belong_group_name -- 所属集团名称
    ,nvl(n.belong_group_orgnz_cd, o.belong_group_orgnz_cd) as belong_group_orgnz_cd -- 所属集团组织机构代码
    ,nvl(n.belong_group_loan_card_no, o.belong_group_loan_card_no) as belong_group_loan_card_no -- 所属集团贷款卡号
    ,nvl(n.belong_group_rgst_cty_rg_cd, o.belong_group_rgst_cty_rg_cd) as belong_group_rgst_cty_rg_cd -- 所属集团注册国家地区代码
    ,nvl(n.belong_group_site_cd, o.belong_group_site_cd) as belong_group_site_cd -- 所属集团所在地代码
    ,nvl(n.belong_group_rgst_addr, o.belong_group_rgst_addr) as belong_group_rgst_addr -- 所属集团注册地址
    ,nvl(n.group_core_mem_flg, o.group_core_mem_flg) as group_core_mem_flg -- 集团核心成员标志
    ,nvl(n.belong_group_dom_work_addr, o.belong_group_dom_work_addr) as belong_group_dom_work_addr -- 所属集团国内办公地址
    ,nvl(n.mem_type_cd, o.mem_type_cd) as mem_type_cd -- 成员类型代码
    ,nvl(n.parent_corp_flg, o.parent_corp_flg) as parent_corp_flg -- 母公司标志
    ,nvl(n.mem_status_cd, o.mem_status_cd) as mem_status_cd -- 成员状态代码
    ,nvl(n.use_family_edit_num, o.use_family_edit_num) as use_family_edit_num -- 当前使用的家谱版本号
    ,nvl(n.matn_family_edit_num, o.matn_family_edit_num) as matn_family_edit_num -- 当前维护的家谱版本号
    ,case when
            n.party_id is null
            and n.lp_id is null
            and n.belong_group_id is null
            and n.data_src_cd is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.party_id is null
            and n.lp_id is null
            and n.belong_group_id is null
            and n.data_src_cd is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.party_id is null
            and n.lp_id is null
            and n.belong_group_id is null
            and n.data_src_cd is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_corp_cust_group_info_h_eifsf1_tm n
    full join (select * from ${iml_schema}.pty_corp_cust_group_info_h_eifsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.party_id = n.party_id
            and o.lp_id = n.lp_id
            and o.belong_group_id = n.belong_group_id
            and o.data_src_cd = n.data_src_cd
where (
        o.party_id is null
        and o.lp_id is null
        and o.belong_group_id is null
        and o.data_src_cd is null
    )
    or (
        n.party_id is null
        and n.lp_id is null
        and n.belong_group_id is null
        and n.data_src_cd is null
    )
    or (
        o.belong_group_name <> n.belong_group_name
        or o.belong_group_orgnz_cd <> n.belong_group_orgnz_cd
        or o.belong_group_loan_card_no <> n.belong_group_loan_card_no
        or o.belong_group_rgst_cty_rg_cd <> n.belong_group_rgst_cty_rg_cd
        or o.belong_group_site_cd <> n.belong_group_site_cd
        or o.belong_group_rgst_addr <> n.belong_group_rgst_addr
        or o.group_core_mem_flg <> n.group_core_mem_flg
        or o.belong_group_dom_work_addr <> n.belong_group_dom_work_addr
        or o.mem_type_cd <> n.mem_type_cd
        or o.parent_corp_flg <> n.parent_corp_flg
        or o.mem_status_cd <> n.mem_status_cd
        or o.use_family_edit_num <> n.use_family_edit_num
        or o.matn_family_edit_num <> n.matn_family_edit_num
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.pty_corp_cust_group_info_h_eifsf1_cl(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,belong_group_id -- 所属集团编号
    ,data_src_cd -- 数据来源代码
    ,belong_group_name -- 所属集团名称
    ,belong_group_orgnz_cd -- 所属集团组织机构代码
    ,belong_group_loan_card_no -- 所属集团贷款卡号
    ,belong_group_rgst_cty_rg_cd -- 所属集团注册国家地区代码
    ,belong_group_site_cd -- 所属集团所在地代码
    ,belong_group_rgst_addr -- 所属集团注册地址
    ,group_core_mem_flg -- 集团核心成员标志
    ,belong_group_dom_work_addr -- 所属集团国内办公地址
    ,mem_type_cd -- 成员类型代码
    ,parent_corp_flg -- 母公司标志
    ,mem_status_cd -- 成员状态代码
    ,use_family_edit_num -- 当前使用的家谱版本号
    ,matn_family_edit_num -- 当前维护的家谱版本号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_corp_cust_group_info_h_eifsf1_op(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,belong_group_id -- 所属集团编号
    ,data_src_cd -- 数据来源代码
    ,belong_group_name -- 所属集团名称
    ,belong_group_orgnz_cd -- 所属集团组织机构代码
    ,belong_group_loan_card_no -- 所属集团贷款卡号
    ,belong_group_rgst_cty_rg_cd -- 所属集团注册国家地区代码
    ,belong_group_site_cd -- 所属集团所在地代码
    ,belong_group_rgst_addr -- 所属集团注册地址
    ,group_core_mem_flg -- 集团核心成员标志
    ,belong_group_dom_work_addr -- 所属集团国内办公地址
    ,mem_type_cd -- 成员类型代码
    ,parent_corp_flg -- 母公司标志
    ,mem_status_cd -- 成员状态代码
    ,use_family_edit_num -- 当前使用的家谱版本号
    ,matn_family_edit_num -- 当前维护的家谱版本号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.party_id -- 当事人编号
    ,o.lp_id -- 法人编号
    ,o.belong_group_id -- 所属集团编号
    ,o.data_src_cd -- 数据来源代码
    ,o.belong_group_name -- 所属集团名称
    ,o.belong_group_orgnz_cd -- 所属集团组织机构代码
    ,o.belong_group_loan_card_no -- 所属集团贷款卡号
    ,o.belong_group_rgst_cty_rg_cd -- 所属集团注册国家地区代码
    ,o.belong_group_site_cd -- 所属集团所在地代码
    ,o.belong_group_rgst_addr -- 所属集团注册地址
    ,o.group_core_mem_flg -- 集团核心成员标志
    ,o.belong_group_dom_work_addr -- 所属集团国内办公地址
    ,o.mem_type_cd -- 成员类型代码
    ,o.parent_corp_flg -- 母公司标志
    ,o.mem_status_cd -- 成员状态代码
    ,o.use_family_edit_num -- 当前使用的家谱版本号
    ,o.matn_family_edit_num -- 当前维护的家谱版本号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    , case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_corp_cust_group_info_h_eifsf1_bk o
    left join ${iml_schema}.pty_corp_cust_group_info_h_eifsf1_op n
        on
            o.party_id = n.party_id
            and o.lp_id = n.lp_id
            and o.belong_group_id = n.belong_group_id
            and o.data_src_cd = n.data_src_cd
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.pty_corp_cust_group_info_h_eifsf1_cl d
        on
            o.party_id = d.party_id
            and o.lp_id = d.lp_id
            and o.belong_group_id = d.belong_group_id
            and o.data_src_cd = d.data_src_cd
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.pty_corp_cust_group_info_h;
--alter table ${iml_schema}.pty_corp_cust_group_info_h truncate partition for ('eifsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('pty_corp_cust_group_info_h') 
               and substr(subpartition_name,1,8)=upper('p_eifsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.pty_corp_cust_group_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.pty_corp_cust_group_info_h modify partition p_eifsf1 
add subpartition p_eifsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.pty_corp_cust_group_info_h exchange subpartition p_eifsf1_${batch_date} with table ${iml_schema}.pty_corp_cust_group_info_h_eifsf1_cl;
alter table ${iml_schema}.pty_corp_cust_group_info_h exchange subpartition p_eifsf1_20991231 with table ${iml_schema}.pty_corp_cust_group_info_h_eifsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.pty_corp_cust_group_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.pty_corp_cust_group_info_h_eifsf1_tm purge;
drop table ${iml_schema}.pty_corp_cust_group_info_h_eifsf1_op purge;
drop table ${iml_schema}.pty_corp_cust_group_info_h_eifsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.pty_corp_cust_group_info_h_eifsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'pty_corp_cust_group_info_h', partname => 'p_eifsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
