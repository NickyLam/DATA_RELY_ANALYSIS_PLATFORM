/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl mtl_fml_f99_int_org_info_new
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.mtl_fml_f99_int_org_info_new
whenever sqlerror continue none;
drop table ${itl_schema}.mtl_fml_f99_int_org_info_new purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.mtl_fml_f99_int_org_info_new(
    etl_dt date
    ,lp_id varchar2(60)
    ,org_id varchar2(60)
    ,org_name varchar2(200)
    ,org_abbr varchar2(200)
    ,princ_emply_id varchar2(60)
    ,cbrc_fin_inst_id varchar2(60)
    ,unionpay_fin_inst_id varchar2(60)
    ,fin_inst_idf_code varchar2(60)
    ,bus_lics_num varchar2(60)
    ,fin_lics_num varchar2(60)
    ,pbc_pay_bank_no varchar2(60)
    ,fin_inst_code varchar2(60)
    ,hq_org_id varchar2(60)
    ,hq_org_name varchar2(200)
    ,brch_id varchar2(60)
    ,brch_name varchar2(200)
    ,subrch_id varchar2(60)
    ,subrch_name varchar2(200)
    ,org_type_cd varchar2(10)
    ,org_lev_cd varchar2(10)
    ,org_hibchy_cd varchar2(10)
    ,org_status_cd varchar2(10)
    ,bus_status_cd varchar2(10)
    ,bus_org_flg varchar2(10)
    ,enty_org_flg varchar2(10)
    ,accti_org_flg varchar2(10)
    ,admin_org_flg varchar2(10)
    ,acct_instit_flg varchar2(10)
    ,vtual_accti_org_flg varchar2(10)
    ,admin_super_org_id varchar2(60)
    ,acct_super_org_id varchar2(60)
    ,accti_super_org_id varchar2(60)
    ,func_org_id varchar2(60)
    ,func_dept_id varchar2(60)
    ,cty_rg_cd varchar2(10)
    ,prov_cd varchar2(10)
    ,city_cd varchar2(10)
    ,county_cd varchar2(10)
    ,phys_addr varchar2(500)
    ,ddd_area_cd varchar2(10)
    ,phone varchar2(60)
    ,zip_cd varchar2(60)
    ,org_found_dt date
    ,org_revo_dt date
    ,org_start_bus_tm varchar2(6)
    ,org_end_bus_tm varchar2(6)
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${itl_schema}.mtl_fml_f99_int_org_info_new to ${iol_schema};

-- comment
comment on table  ${itl_schema}.mtl_fml_f99_int_org_info_new is 'FML_F99_内部机构信息';
comment on column ${itl_schema}.mtl_fml_f99_int_org_info_new.ETL_DT is '数据日期';                                    
comment on column ${itl_schema}.mtl_fml_f99_int_org_info_new.LP_ID is '法人编号';                                     
comment on column ${itl_schema}.mtl_fml_f99_int_org_info_new.ORG_ID is '机构编号';                                    
comment on column ${itl_schema}.mtl_fml_f99_int_org_info_new.ORG_NAME is '机构名称';                                  
comment on column ${itl_schema}.mtl_fml_f99_int_org_info_new.ORG_ABBR is '机构简称';                                  
comment on column ${itl_schema}.mtl_fml_f99_int_org_info_new.PRINC_EMPLY_ID is '负责人员工编号';                         
comment on column ${itl_schema}.mtl_fml_f99_int_org_info_new.CBRC_FIN_INST_ID is '银监会金融机构编号';                     
comment on column ${itl_schema}.mtl_fml_f99_int_org_info_new.UNIONPAY_FIN_INST_ID is '银联金融机构编号';                  
comment on column ${itl_schema}.mtl_fml_f99_int_org_info_new.FIN_INST_IDF_CODE is '金融机构标识码';                      
comment on column ${itl_schema}.mtl_fml_f99_int_org_info_new.BUS_LICS_NUM is '营业执照号码';                            
comment on column ${itl_schema}.mtl_fml_f99_int_org_info_new.FIN_LICS_NUM is '金融许可证号';                            
comment on column ${itl_schema}.mtl_fml_f99_int_org_info_new.PBC_PAY_BANK_NO is '人行支付行号';                         
comment on column ${itl_schema}.mtl_fml_f99_int_org_info_new.FIN_INST_CODE is '金融机构编码';                           
comment on column ${itl_schema}.mtl_fml_f99_int_org_info_new.HQ_ORG_ID is '总行机构编号';                               
comment on column ${itl_schema}.mtl_fml_f99_int_org_info_new.HQ_ORG_NAME is '总行机构名称';                             
comment on column ${itl_schema}.mtl_fml_f99_int_org_info_new.BRCH_ID is '分行编号';                                   
comment on column ${itl_schema}.mtl_fml_f99_int_org_info_new.BRCH_NAME is '分行名称';                                 
comment on column ${itl_schema}.mtl_fml_f99_int_org_info_new.SUBRCH_ID is '支行编号';                                 
comment on column ${itl_schema}.mtl_fml_f99_int_org_info_new.SUBRCH_NAME is '支行名称';                               
comment on column ${itl_schema}.mtl_fml_f99_int_org_info_new.ORG_TYPE_CD is '机构类型代码';                             
comment on column ${itl_schema}.mtl_fml_f99_int_org_info_new.ORG_LEV_CD is '机构级别代码';                              
comment on column ${itl_schema}.mtl_fml_f99_int_org_info_new.ORG_HIBCHY_CD is '机构层级代码';                           
comment on column ${itl_schema}.mtl_fml_f99_int_org_info_new.ORG_STATUS_CD is '机构状态代码';                           
comment on column ${itl_schema}.mtl_fml_f99_int_org_info_new.BUS_STATUS_CD is '营业状态代码';                           
comment on column ${itl_schema}.mtl_fml_f99_int_org_info_new.BUS_ORG_FLG is '营业机构标志';                             
comment on column ${itl_schema}.mtl_fml_f99_int_org_info_new.ENTY_ORG_FLG is '实体机构标志';                            
comment on column ${itl_schema}.mtl_fml_f99_int_org_info_new.ACCTI_ORG_FLG is '核算机构标志';                           
comment on column ${itl_schema}.mtl_fml_f99_int_org_info_new.ADMIN_ORG_FLG is '行政机构标志';                           
comment on column ${itl_schema}.mtl_fml_f99_int_org_info_new.ACCT_INSTIT_FLG is '账务机构标志';                         
comment on column ${itl_schema}.mtl_fml_f99_int_org_info_new.VTUAL_ACCTI_ORG_FLG is '虚拟核算机构标志';                   
comment on column ${itl_schema}.mtl_fml_f99_int_org_info_new.ADMIN_SUPER_ORG_ID is '行政上级机构编号';                    
comment on column ${itl_schema}.mtl_fml_f99_int_org_info_new.ACCT_SUPER_ORG_ID is '账务上级机构编号';                     
comment on column ${itl_schema}.mtl_fml_f99_int_org_info_new.ACCTI_SUPER_ORG_ID is '核算上级机构编号';                    
comment on column ${itl_schema}.mtl_fml_f99_int_org_info_new.FUNC_ORG_ID is '职能机构编号' ;                            
comment on column ${itl_schema}.mtl_fml_f99_int_org_info_new.FUNC_DEPT_ID is '职能部门编号' ;                           
comment on column ${itl_schema}.mtl_fml_f99_int_org_info_new.CTY_RG_CD is '国家和地区代码';                              
comment on column ${itl_schema}.mtl_fml_f99_int_org_info_new.PROV_CD is '省代码';                                    
comment on column ${itl_schema}.mtl_fml_f99_int_org_info_new.CITY_CD is '市代码';                                    
comment on column ${itl_schema}.mtl_fml_f99_int_org_info_new.COUNTY_CD is '县代码';                                  
comment on column ${itl_schema}.mtl_fml_f99_int_org_info_new.PHYS_ADDR is '物理地址';                                 
comment on column ${itl_schema}.mtl_fml_f99_int_org_info_new.DDD_AREA_CD is '国内长途区号';                             
comment on column ${itl_schema}.mtl_fml_f99_int_org_info_new.PHONE is '联系电话';                                     
comment on column ${itl_schema}.mtl_fml_f99_int_org_info_new.ZIP_CD is '邮政编码';                                    
comment on column ${itl_schema}.mtl_fml_f99_int_org_info_new.ORG_FOUND_DT is '机构成立日期';                            
comment on column ${itl_schema}.mtl_fml_f99_int_org_info_new.ORG_REVO_DT is '机构撤销日期';                             
comment on column ${itl_schema}.mtl_fml_f99_int_org_info_new.ORG_START_BUS_TM is '机构开始营业时间';                      
comment on column ${itl_schema}.mtl_fml_f99_int_org_info_new.ORG_END_BUS_TM is '机构结束营业时间';                        
comment on column ${itl_schema}.mtl_fml_f99_int_org_info_new.etl_timestamp is 'ETL处理时间戳' ;


-- 数据转移,旧表转移到新表
-- 1.添加分区

alter table mtl_fml_f99_int_org_info_new add partition p_20180827 values (to_date( '20180827 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20180828 values (to_date( '20180828 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20180829 values (to_date( '20180829 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20181130 values (to_date( '20181130 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20181231 values (to_date( '20181231 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20190131 values (to_date( '20190131 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20190228 values (to_date( '20190228 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20190331 values (to_date( '20190331 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20190430 values (to_date( '20190430 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20190531 values (to_date( '20190531 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20190630 values (to_date( '20190630 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20190731 values (to_date( '20190731 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20190827 values (to_date( '20190827 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20190828 values (to_date( '20190828 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20190829 values (to_date( '20190829 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20190830 values (to_date( '20190830 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20190831 values (to_date( '20190831 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20190901 values (to_date( '20190901 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20190902 values (to_date( '20190902 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20190903 values (to_date( '20190903 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20190904 values (to_date( '20190904 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20190905 values (to_date( '20190905 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20190906 values (to_date( '20190906 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20190907 values (to_date( '20190907 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20190908 values (to_date( '20190908 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20190909 values (to_date( '20190909 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20190910 values (to_date( '20190910 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20190911 values (to_date( '20190911 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20190912 values (to_date( '20190912 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20190913 values (to_date( '20190913 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20190914 values (to_date( '20190914 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20190915 values (to_date( '20190915 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20190916 values (to_date( '20190916 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20190917 values (to_date( '20190917 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20190918 values (to_date( '20190918 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20190919 values (to_date( '20190919 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20190920 values (to_date( '20190920 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20190921 values (to_date( '20190921 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20190922 values (to_date( '20190922 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20190923 values (to_date( '20190923 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20190924 values (to_date( '20190924 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20190925 values (to_date( '20190925 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20190926 values (to_date( '20190926 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20190927 values (to_date( '20190927 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20190928 values (to_date( '20190928 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20190929 values (to_date( '20190929 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20190930 values (to_date( '20190930 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191001 values (to_date( '20191001 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191002 values (to_date( '20191002 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191003 values (to_date( '20191003 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191004 values (to_date( '20191004 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191005 values (to_date( '20191005 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191006 values (to_date( '20191006 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191007 values (to_date( '20191007 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191008 values (to_date( '20191008 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191009 values (to_date( '20191009 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191010 values (to_date( '20191010 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191011 values (to_date( '20191011 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191012 values (to_date( '20191012 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191013 values (to_date( '20191013 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191014 values (to_date( '20191014 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191015 values (to_date( '20191015 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191016 values (to_date( '20191016 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191017 values (to_date( '20191017 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191018 values (to_date( '20191018 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191019 values (to_date( '20191019 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191020 values (to_date( '20191020 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191021 values (to_date( '20191021 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191022 values (to_date( '20191022 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191023 values (to_date( '20191023 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191024 values (to_date( '20191024 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191025 values (to_date( '20191025 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191026 values (to_date( '20191026 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191027 values (to_date( '20191027 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191028 values (to_date( '20191028 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191029 values (to_date( '20191029 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191030 values (to_date( '20191030 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191031 values (to_date( '20191031 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191101 values (to_date( '20191101 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191102 values (to_date( '20191102 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191103 values (to_date( '20191103 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191104 values (to_date( '20191104 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191105 values (to_date( '20191105 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191106 values (to_date( '20191106 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191107 values (to_date( '20191107 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191108 values (to_date( '20191108 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191109 values (to_date( '20191109 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191110 values (to_date( '20191110 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191111 values (to_date( '20191111 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191112 values (to_date( '20191112 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191113 values (to_date( '20191113 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191114 values (to_date( '20191114 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191115 values (to_date( '20191115 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191116 values (to_date( '20191116 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191117 values (to_date( '20191117 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191118 values (to_date( '20191118 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191119 values (to_date( '20191119 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191120 values (to_date( '20191120 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191121 values (to_date( '20191121 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191122 values (to_date( '20191122 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191123 values (to_date( '20191123 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191124 values (to_date( '20191124 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191125 values (to_date( '20191125 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191126 values (to_date( '20191126 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191127 values (to_date( '20191127 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191128 values (to_date( '20191128 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191129 values (to_date( '20191129 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191130 values (to_date( '20191130 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191201 values (to_date( '20191201 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191202 values (to_date( '20191202 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191203 values (to_date( '20191203 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191204 values (to_date( '20191204 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191205 values (to_date( '20191205 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191206 values (to_date( '20191206 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191207 values (to_date( '20191207 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191208 values (to_date( '20191208 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191209 values (to_date( '20191209 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191210 values (to_date( '20191210 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191211 values (to_date( '20191211 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191212 values (to_date( '20191212 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191213 values (to_date( '20191213 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191214 values (to_date( '20191214 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191215 values (to_date( '20191215 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191216 values (to_date( '20191216 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191217 values (to_date( '20191217 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191218 values (to_date( '20191218 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191219 values (to_date( '20191219 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191220 values (to_date( '20191220 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191221 values (to_date( '20191221 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191222 values (to_date( '20191222 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191223 values (to_date( '20191223 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191224 values (to_date( '20191224 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191225 values (to_date( '20191225 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191226 values (to_date( '20191226 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191227 values (to_date( '20191227 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191228 values (to_date( '20191228 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191229 values (to_date( '20191229 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191230 values (to_date( '20191230 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20191231 values (to_date( '20191231 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200101 values (to_date( '20200101 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200102 values (to_date( '20200102 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200103 values (to_date( '20200103 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200104 values (to_date( '20200104 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200105 values (to_date( '20200105 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200106 values (to_date( '20200106 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200107 values (to_date( '20200107 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200108 values (to_date( '20200108 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200109 values (to_date( '20200109 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200110 values (to_date( '20200110 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200111 values (to_date( '20200111 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200112 values (to_date( '20200112 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200113 values (to_date( '20200113 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200114 values (to_date( '20200114 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200115 values (to_date( '20200115 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200116 values (to_date( '20200116 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200117 values (to_date( '20200117 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200118 values (to_date( '20200118 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200119 values (to_date( '20200119 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200120 values (to_date( '20200120 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200121 values (to_date( '20200121 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200122 values (to_date( '20200122 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200123 values (to_date( '20200123 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200124 values (to_date( '20200124 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200125 values (to_date( '20200125 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200126 values (to_date( '20200126 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200127 values (to_date( '20200127 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200128 values (to_date( '20200128 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200129 values (to_date( '20200129 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200130 values (to_date( '20200130 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200131 values (to_date( '20200131 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200201 values (to_date( '20200201 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200202 values (to_date( '20200202 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200203 values (to_date( '20200203 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200204 values (to_date( '20200204 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200205 values (to_date( '20200205 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200206 values (to_date( '20200206 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200207 values (to_date( '20200207 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200208 values (to_date( '20200208 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200209 values (to_date( '20200209 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200210 values (to_date( '20200210 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200211 values (to_date( '20200211 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200212 values (to_date( '20200212 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200213 values (to_date( '20200213 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200214 values (to_date( '20200214 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200215 values (to_date( '20200215 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200216 values (to_date( '20200216 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200217 values (to_date( '20200217 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200218 values (to_date( '20200218 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200219 values (to_date( '20200219 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200220 values (to_date( '20200220 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200221 values (to_date( '20200221 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200222 values (to_date( '20200222 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200223 values (to_date( '20200223 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200224 values (to_date( '20200224 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200225 values (to_date( '20200225 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200226 values (to_date( '20200226 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200227 values (to_date( '20200227 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200228 values (to_date( '20200228 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200229 values (to_date( '20200229 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200301 values (to_date( '20200301 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200302 values (to_date( '20200302 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200303 values (to_date( '20200303 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200304 values (to_date( '20200304 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200305 values (to_date( '20200305 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200306 values (to_date( '20200306 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200307 values (to_date( '20200307 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200308 values (to_date( '20200308 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200309 values (to_date( '20200309 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200310 values (to_date( '20200310 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200311 values (to_date( '20200311 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200312 values (to_date( '20200312 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200313 values (to_date( '20200313 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200314 values (to_date( '20200314 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200315 values (to_date( '20200315 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200316 values (to_date( '20200316 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200317 values (to_date( '20200317 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200318 values (to_date( '20200318 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200319 values (to_date( '20200319 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200320 values (to_date( '20200320 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200321 values (to_date( '20200321 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200322 values (to_date( '20200322 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200323 values (to_date( '20200323 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200324 values (to_date( '20200324 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200325 values (to_date( '20200325 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200326 values (to_date( '20200326 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200327 values (to_date( '20200327 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200328 values (to_date( '20200328 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200329 values (to_date( '20200329 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200330 values (to_date( '20200330 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200331 values (to_date( '20200331 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200401 values (to_date( '20200401 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200402 values (to_date( '20200402 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200403 values (to_date( '20200403 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200404 values (to_date( '20200404 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200405 values (to_date( '20200405 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200406 values (to_date( '20200406 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200407 values (to_date( '20200407 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200408 values (to_date( '20200408 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200409 values (to_date( '20200409 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200410 values (to_date( '20200410 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200411 values (to_date( '20200411 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200412 values (to_date( '20200412 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200413 values (to_date( '20200413 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200414 values (to_date( '20200414 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200415 values (to_date( '20200415 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200416 values (to_date( '20200416 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200417 values (to_date( '20200417 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200418 values (to_date( '20200418 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200419 values (to_date( '20200419 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200420 values (to_date( '20200420 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200421 values (to_date( '20200421 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200422 values (to_date( '20200422 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200423 values (to_date( '20200423 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200424 values (to_date( '20200424 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200425 values (to_date( '20200425 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200426 values (to_date( '20200426 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200427 values (to_date( '20200427 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200428 values (to_date( '20200428 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200429 values (to_date( '20200429 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200430 values (to_date( '20200430 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200501 values (to_date( '20200501 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200502 values (to_date( '20200502 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200503 values (to_date( '20200503 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200504 values (to_date( '20200504 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200505 values (to_date( '20200505 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200506 values (to_date( '20200506 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200507 values (to_date( '20200507 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200508 values (to_date( '20200508 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200509 values (to_date( '20200509 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200510 values (to_date( '20200510 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200511 values (to_date( '20200511 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200512 values (to_date( '20200512 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200513 values (to_date( '20200513 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200514 values (to_date( '20200514 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200515 values (to_date( '20200515 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200516 values (to_date( '20200516 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200517 values (to_date( '20200517 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200518 values (to_date( '20200518 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200519 values (to_date( '20200519 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200520 values (to_date( '20200520 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200521 values (to_date( '20200521 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200522 values (to_date( '20200522 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200523 values (to_date( '20200523 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200524 values (to_date( '20200524 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200525 values (to_date( '20200525 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200526 values (to_date( '20200526 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200527 values (to_date( '20200527 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200528 values (to_date( '20200528 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200529 values (to_date( '20200529 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200530 values (to_date( '20200530 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200531 values (to_date( '20200531 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200601 values (to_date( '20200601 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200602 values (to_date( '20200602 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200603 values (to_date( '20200603 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200604 values (to_date( '20200604 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200605 values (to_date( '20200605 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200606 values (to_date( '20200606 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200607 values (to_date( '20200607 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200608 values (to_date( '20200608 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200609 values (to_date( '20200609 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200610 values (to_date( '20200610 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200611 values (to_date( '20200611 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200612 values (to_date( '20200612 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200613 values (to_date( '20200613 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200614 values (to_date( '20200614 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200615 values (to_date( '20200615 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200616 values (to_date( '20200616 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200617 values (to_date( '20200617 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200618 values (to_date( '20200618 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200619 values (to_date( '20200619 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200620 values (to_date( '20200620 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200621 values (to_date( '20200621 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200622 values (to_date( '20200622 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200623 values (to_date( '20200623 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200624 values (to_date( '20200624 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200625 values (to_date( '20200625 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200626 values (to_date( '20200626 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200627 values (to_date( '20200627 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200628 values (to_date( '20200628 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200629 values (to_date( '20200629 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200630 values (to_date( '20200630 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200701 values (to_date( '20200701 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200702 values (to_date( '20200702 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200703 values (to_date( '20200703 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200704 values (to_date( '20200704 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200705 values (to_date( '20200705 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200706 values (to_date( '20200706 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200707 values (to_date( '20200707 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200708 values (to_date( '20200708 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200709 values (to_date( '20200709 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200710 values (to_date( '20200710 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200711 values (to_date( '20200711 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200712 values (to_date( '20200712 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200713 values (to_date( '20200713 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200714 values (to_date( '20200714 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200715 values (to_date( '20200715 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200716 values (to_date( '20200716 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200717 values (to_date( '20200717 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200718 values (to_date( '20200718 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200719 values (to_date( '20200719 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200720 values (to_date( '20200720 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200721 values (to_date( '20200721 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200722 values (to_date( '20200722 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200723 values (to_date( '20200723 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200724 values (to_date( '20200724 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200725 values (to_date( '20200725 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200726 values (to_date( '20200726 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200727 values (to_date( '20200727 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200728 values (to_date( '20200728 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200729 values (to_date( '20200729 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200730 values (to_date( '20200730 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200731 values (to_date( '20200731 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200801 values (to_date( '20200801 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200802 values (to_date( '20200802 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200803 values (to_date( '20200803 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200804 values (to_date( '20200804 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200805 values (to_date( '20200805 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200806 values (to_date( '20200806 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200807 values (to_date( '20200807 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200808 values (to_date( '20200808 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200809 values (to_date( '20200809 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200810 values (to_date( '20200810 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200811 values (to_date( '20200811 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200812 values (to_date( '20200812 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200813 values (to_date( '20200813 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200814 values (to_date( '20200814 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200815 values (to_date( '20200815 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200816 values (to_date( '20200816 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200817 values (to_date( '20200817 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200818 values (to_date( '20200818 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200819 values (to_date( '20200819 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200820 values (to_date( '20200820 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200821 values (to_date( '20200821 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200822 values (to_date( '20200822 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200823 values (to_date( '20200823 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200824 values (to_date( '20200824 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200825 values (to_date( '20200825 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200826 values (to_date( '20200826 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200827 values (to_date( '20200827 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200828 values (to_date( '20200828 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200829 values (to_date( '20200829 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200830 values (to_date( '20200830 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200831 values (to_date( '20200831 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200901 values (to_date( '20200901 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200902 values (to_date( '20200902 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200903 values (to_date( '20200903 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200904 values (to_date( '20200904 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200905 values (to_date( '20200905 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200906 values (to_date( '20200906 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200907 values (to_date( '20200907 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200908 values (to_date( '20200908 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200909 values (to_date( '20200909 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200910 values (to_date( '20200910 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200911 values (to_date( '20200911 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200912 values (to_date( '20200912 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200913 values (to_date( '20200913 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200914 values (to_date( '20200914 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200915 values (to_date( '20200915 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200916 values (to_date( '20200916 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200917 values (to_date( '20200917 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200918 values (to_date( '20200918 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200919 values (to_date( '20200919 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200920 values (to_date( '20200920 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200921 values (to_date( '20200921 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200922 values (to_date( '20200922 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200923 values (to_date( '20200923 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200924 values (to_date( '20200924 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200925 values (to_date( '20200925 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200926 values (to_date( '20200926 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200927 values (to_date( '20200927 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200928 values (to_date( '20200928 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200929 values (to_date( '20200929 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20200930 values (to_date( '20200930 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20201001 values (to_date( '20201001 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20201002 values (to_date( '20201002 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20201003 values (to_date( '20201003 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20201004 values (to_date( '20201004 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20201005 values (to_date( '20201005 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20201006 values (to_date( '20201006 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20201007 values (to_date( '20201007 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20201008 values (to_date( '20201008 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20201009 values (to_date( '20201009 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20201010 values (to_date( '20201010 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20201011 values (to_date( '20201011 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20201012 values (to_date( '20201012 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20201013 values (to_date( '20201013 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20201014 values (to_date( '20201014 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20201015 values (to_date( '20201015 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20201016 values (to_date( '20201016 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20201017 values (to_date( '20201017 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20201018 values (to_date( '20201018 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20201019 values (to_date( '20201019 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20201020 values (to_date( '20201020 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20201021 values (to_date( '20201021 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20201022 values (to_date( '20201022 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20201023 values (to_date( '20201023 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20201024 values (to_date( '20201024 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20201025 values (to_date( '20201025 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20201026 values (to_date( '20201026 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20201027 values (to_date( '20201027 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20201028 values (to_date( '20201028 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20201029 values (to_date( '20201029 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20201030 values (to_date( '20201030 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20201031 values (to_date( '20201031 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20201101 values (to_date( '20201101 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20201102 values (to_date( '20201102 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20201103 values (to_date( '20201103 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20201104 values (to_date( '20201104 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20201105 values (to_date( '20201105 ','yyyymmdd')) ;
alter table mtl_fml_f99_int_org_info_new add partition p_20290630 values (to_date( '20290630 ','yyyymmdd')) ;

-- 2.数据插入
insert into mtl_fml_f99_int_org_info_new
(
     ORG_ID 
    ,ORG_NAME 
    ,ORG_ABBR 
    ,ORG_LEV_CD 
    ,ORG_STATUS_CD 
    ,ACCT_INSTIT_FLG 
    ,ADMIN_SUPER_ORG_ID
    ,ORG_FOUND_DT 
    ,ORG_REVO_DT 
    ,ETL_DT
    ,ETL_TIMESTAMP 
)
select 
     ORG_NO 
    ,ORG_NAME 
    ,ORG_ABBR 
    ,ORG_LEVEL_CD 
    ,ORG_STATUS_CD 
    ,ACCTS_ORG_IND 
    ,SUPER_ORG_NO 
    ,ORG_EFFECT_DT 
    ,ORG_INVALID_DT
    ,ETL_DT
    ,ETL_TIMESTAMP 
from mtl_fml_f99_int_org_info
;
commit ;