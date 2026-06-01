/*
purpose:    共性加工层-自助设备信息:自助设备信息，数据主要来源ATM监控系统设备基本信息表
author:     sunline
usage:      python $ETL_HOME/script/main.py 20200930 icl_cmm_self_equip_info
createdate: 20200612
logs:       20201029 陈伟峰 增加第二组POS设备信息；调整第二组的过滤条件；新增字段【设备安装地址、设备种类名称】；新增第三组【直连POS】；增加主键【渠道编号】
            20210122 陈伟峰 调整第二组逻辑
			20250508 陈  凭 调整取数源：删除MRMS取数源（2组）：POS终端信息、直联终端信息；新增AMSS取数源（共三组）：直连POS终端、条码商户虚拟终端、二维码
			20250822 陈伟峰 新增字段【自助设备型号描述、设备供应商名称、设备维护商名称、设备启用日期、设备停用日期】
			20251023 谢  宁 新增字段 【终端编号】
            20251021 陈伟峰 调整字段【自助设备型号描述】取数逻辑
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_self_equip_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_self_equip_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 1.2 drop temporary table cmm_self_equip_info_ex
whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_self_equip_info_ex purge;

-- 2.1 create temporary table cmm_self_equip_info_ex
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_self_equip_info_ex
nologging
compress ${option_switch} for query high
as
select * from ${icl_schema}.cmm_self_equip_info where 0=1;

-- 2.2 insert into data to temporary table cmm_self_equip_info_ex

--第一组（共三组）自助设备信息

whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_self_equip_info_ex(
	etl_dt                            -- 数据日期
	,lp_id                            -- 法人编号
	,equip_id                   	  -- 设备编号
    ,equip_ip_addr_id           	  -- 设备IP地址编号
    ,belong_org_id              	  -- 所属机构编号
    ,in_bank_flg                	  -- 在行标志
	,termn_id                         -- 终端编号
    ,self_equip_model           	  -- 自助设备设备型号
    ,self_equip_type_cd         	  -- 自助设备类型代码
    ,self_equip_model_descb           -- 自助设备型号描述
    ,equip_type_name            	  -- 设备类型名称
    ,equip_type_name_cn_descb   	  -- 设备类型名称中文描述
    ,equip_provi_name                 -- 设备供应商名称
    ,equip_status_cd            	  -- 设备状态代码
    ,equip_matnce_id            	  -- 设备维护商编号
    ,equip_matnce_name                -- 设备维护商名称
    ,equip_install_dt           	  -- 设备安装日期
    ,equip_start_use_dt               -- 设备启用日期
    ,equip_stop_use_dt                -- 设备停用日期
    ,cash_flg                   	  -- 现金标志
    ,install_way_cd             	  -- 安装方式代码
    ,dist_cd                    	  -- 行政区划代码
    ,chn_id                     	  -- 渠道编号
    ,equip_install_addr               -- 设备安装地址
    ,equip_kind_name                  -- 设备种类名称
	,job_cd                           -- 任务代码
	,etl_timestamp                    -- 数据处理时间
)
select to_date('${batch_date}','yyyymmdd')          -- 数据日期
       ,t1.lp_id                                    -- 法人编号
       ,t1.equip_id          				        -- 设备编号
       ,t1.termn_id          				        -- 设备IP地址编号
       ,t1.belong_org_id     				        -- 所属机构编号
       ,t1.in_bank_flg       				        -- 在行标志
	   ,t1.termn_id                              -- 终端编号
       ,t1.equip_model     	 				        -- 自助设备设备型号
       ,t1.equip_type_cd     				        -- 自助设备类型代码
       ,t5.name                                     -- 自助设备型号描述
       ,t2.name              				        -- 设备类型名称
       ,t1.equip_type_name   				        -- 设备类型名称中文描述
       ,t3.name                                     -- 设备供应商名称	
       ,t1.equip_status_cd   				        -- 设备状态代码
       ,t1.equip_matnce_id   				        -- 设备维护商编号
       ,t4.name                                     -- 设备维护商名称
       ,t1.equip_install_dt  				        -- 设备安装日期
       ,to_date(trim(t6.start_date),'yyyy-mm-dd')                               -- 设备启用日期
       ,to_date(trim(t6.stop_date),'yyyy-mm-dd')                                -- 设备停用日期
       ,t1.cash_flg          				        -- 现金标志
       ,t1.install_way_cd    				        -- 安装方式代码
       ,t1.dist_cd           				        -- 行政区划代码
       ,t1.chn_id            				        -- 渠道编号
       ,t1.equip_addr                               -- 设备安装地址
       ,'ATM终端'                                   -- 设备种类名称
       ,t1.job_cd                                                         -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')   -- etl处理时间戳
 from ${iml_schema}.chn_termn_equip_basic_info_h t1
 left join  ${iol_schema}.atms_dev_catalog_table t2
   on t2.no = t1.equip_type_cd
  and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
left join ${iol_schema}.atms_dev_base_info t1a
   on t1.equip_id=t1a.no
  and t1a.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t1a.end_dt > to_date('${batch_date}', 'yyyymmdd')
 left join ${iol_schema}.atms_dev_vendor_table t3
    on t1a.dev_vendor=t3.no
  and t3.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t3.end_dt > to_date('${batch_date}', 'yyyymmdd')
 left join ${iol_schema}.atms_dev_service_company t4
    on t1.equip_matnce_id=t4.no
  and t4.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t4.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iol_schema}.atms_dev_type_table t5
    on t1a.dev_type=t5.no
  and t5.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t5.end_dt > to_date('${batch_date}', 'yyyymmdd')
 left join ${iol_schema}.atms_dev_base_info t6
    on t1.equip_id=t6.no
  and t6.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t6.end_dt > to_date('${batch_date}', 'yyyymmdd')
where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
  and t1.job_cd = 'atmsf1';

commit;

--第二组（共四组）直连POS终端

whenever sqlerror exit sql.sqlcode;
insert /*+ append */  into ${icl_schema}.cmm_self_equip_info_ex(
	etl_dt                            -- 数据日期
	,lp_id                            -- 法人编号
	,equip_id                   	  -- 设备编号
    ,equip_ip_addr_id           	  -- 设备IP地址编号
    ,belong_org_id              	  -- 所属机构编号
    ,in_bank_flg                	  -- 在行标志
	,termn_id                         -- 终端编号
    ,self_equip_model           	  -- 自助设备设备型号
    ,self_equip_type_cd         	  -- 自助设备类型代码
    ,self_equip_model_descb           -- 自助设备型号描述
    ,equip_type_name            	  -- 设备类型名称
    ,equip_type_name_cn_descb   	  -- 设备类型名称中文描述
    ,equip_provi_name                 -- 设备供应商名称
    ,equip_status_cd            	  -- 设备状态代码
    ,equip_matnce_id            	  -- 设备维护商编号
    ,equip_matnce_name                -- 设备维护商名称
    ,equip_install_dt           	  -- 设备安装日期
    ,equip_start_use_dt               -- 设备启用日期
    ,equip_stop_use_dt                -- 设备停用日期
    ,cash_flg                   	  -- 现金标志
    ,install_way_cd             	  -- 安装方式代码
    ,dist_cd                    	  -- 行政区划代码
    ,chn_id                     	  -- 渠道编号
    ,equip_install_addr               -- 设备安装地址
    ,equip_kind_name                  -- 设备种类名称
	,job_cd                           -- 任务代码
	,etl_timestamp                    -- 数据处理时间
)
select to_date('${batch_date}','yyyymmdd')		                      -- 数据日期
       ,'9999'		                                                      -- 法人编号
       ,t1.term_no                                                        -- 设备编号
       ,''                                                                -- 设备ip地址编号
       ,t3.bank_channel_id                                                -- 所属机构编号
       ,'1'                                                               -- 在行标志
	   ,t1.term_no                                                        -- 终端编号
       ,t1.product_no                                                     -- 自助设备设备型号
       ,t1.term_type                                                      -- 自助设备类型代码
       ,t1.term_type                                                      -- 自助设备型号描述
       ,t2.cd_descb                                                       -- 设备类型名称
       ,t2.cd_descb                                                       -- 设备类型名称中文描述
       ,t1.producer                                                       -- 设备供应商名称
       ,to_char(decode(t1.term_status,' ','-',t1.term_status))      -- 设备状态代码
       ,t1.mch_no                                                         -- 设备维护商编号
       ,''                                                                -- 设备维护商名称
       ,t1.create_time                                                    -- 设备安装日期
       ,t1.create_time                                                    -- 设备启用日期
       ,''                                                                -- 设备停用日期
       ,''                                                                -- 现金标志
       ,'-'                                                               -- 安装方式代码
       ,nvl(trim(t1.use_region_code),'000000')                         -- 行政区划代码
       ,'0000'                                                            -- 渠道编号
       ,t1.term_address                                                   -- 设备安装地址
       ,'直连POS终端'                                                     -- 设备种类名称
       ,'amssf1'                                                          -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')   -- etl处理时间戳
 from ${iol_schema}.amss_cms_direct_mch_pos t1
 left join ${iml_schema}.ref_pub_cd t2
   on t1.term_type = t2.cd_val
  and t2.cd_id = 'CD2148'
  --and t2.etl_dt = to_date('${batch_date}','yyyymmdd')
 left join ${iol_schema}.amss_cms_channel t3
   on t1.aff_channel = t3.channel_id
  and t3.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t3.end_dt > to_date('${batch_date}','yyyymmdd')
where trim(t1.term_no) is not null
  and t1.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t1.end_dt > to_date('${batch_date}','yyyymmdd');
commit;


--第三组（共四组）条码商户虚拟终端

whenever sqlerror exit sql.sqlcode;
insert /*+ append */  into ${icl_schema}.cmm_self_equip_info_ex(
	etl_dt                            -- 数据日期
	,lp_id                            -- 法人编号
	,equip_id                   	  -- 设备编号
    ,equip_ip_addr_id           	  -- 设备IP地址编号
    ,belong_org_id              	  -- 所属机构编号
    ,in_bank_flg                	  -- 在行标志
	,termn_id                         -- 终端编号
    ,self_equip_model           	  -- 自助设备设备型号
    ,self_equip_type_cd         	  -- 自助设备类型代码
    ,self_equip_model_descb           -- 自助设备型号描述
    ,equip_type_name            	  -- 设备类型名称
    ,equip_type_name_cn_descb   	  -- 设备类型名称中文描述
    ,equip_provi_name                 -- 设备供应商名称
    ,equip_status_cd            	  -- 设备状态代码
    ,equip_matnce_id            	  -- 设备维护商编号
    ,equip_matnce_name                -- 设备维护商名称
    ,equip_install_dt           	  -- 设备安装日期
    ,equip_start_use_dt               -- 设备启用日期
    ,equip_stop_use_dt                -- 设备停用日期
    ,cash_flg                   	  -- 现金标志
    ,install_way_cd             	  -- 安装方式代码
    ,dist_cd                    	  -- 行政区划代码
    ,chn_id                     	  -- 渠道编号
    ,equip_install_addr               -- 设备安装地址
    ,equip_kind_name                  -- 设备种类名称
	,job_cd                           -- 任务代码
	,etl_timestamp                    -- 数据处理时间
)
select to_date('${batch_date}','yyyymmdd')		                          -- 数据日期
       ,'9999'		                                                      -- 法人编号
       ,t1.term_no                                                        -- 设备编号
       ,''                                                                -- 设备ip地址编号
       ,t2.bank_channel_id                                                -- 所属机构编号
       ,'1'                                                               -- 在行标志
	   ,t1.term_no                                                        -- 终端编号
       ,t1.device_model                                                   -- 自助设备设备型号
       ,t1.device_type                                                    -- 自助设备类型代码
       ,t1.device_type_name                                               -- 自助设备型号描述
       ,t1.device_type_name                                               -- 设备类型名称
       ,t1.device_type_name                                               -- 设备类型名称中文描述
       ,t1.vn_name                                                        -- 设备供应商名称
       ,decode(t1.term_status,'0','3',' ','-',t1.term_status)          -- 设备状态代码
       ,t1.mch_id                                                         -- 设备维护商编号
       ,t1.mch_name                                                       -- 设备维护商名称
       ,t1.sn_bind_time                                                   -- 设备安装日期
       ,t1.sn_bind_time                                                   -- 设备启用日期
       ,t1.sn_unbind_time                                                 -- 设备停用日期
       ,''                                                                -- 现金标志
       ,'-'                                                               -- 安装方式代码
       ,'000000'                                                          -- 行政区划代码
       ,'0000'                                                            -- 渠道编号
       ,t1.term_addr                                                      -- 设备安装地址
       ,'条码商户虚拟终端'                                                -- 设备种类名称
       ,'amssf1'                                                          -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')   -- etl处理时间戳
 from ${iol_schema}.amss_cms_device_info t1
 left join ${iol_schema}.amss_cms_channel t2
   on t1.channel_id = t2.channel_id
  and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t2.end_dt > to_date('${batch_date}','yyyymmdd')
where trim(t1.term_no) is not null
  and t1.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t1.end_dt > to_date('${batch_date}','yyyymmdd');
commit;

--第四组（共四组）二维码

whenever sqlerror exit sql.sqlcode;
insert /*+ append */  into ${icl_schema}.cmm_self_equip_info_ex(
	etl_dt                            -- 数据日期
	,lp_id                            -- 法人编号
	,equip_id                   	  -- 设备编号
    ,equip_ip_addr_id           	  -- 设备IP地址编号
    ,belong_org_id              	  -- 所属机构编号
    ,in_bank_flg                	  -- 在行标志
	,termn_id                         -- 终端编号
    ,self_equip_model           	  -- 自助设备设备型号
    ,self_equip_type_cd         	  -- 自助设备类型代码
    ,self_equip_model_descb           -- 自助设备型号描述
    ,equip_type_name            	  -- 设备类型名称
    ,equip_type_name_cn_descb   	  -- 设备类型名称中文描述
    ,equip_provi_name                 -- 设备供应商名称
    ,equip_status_cd            	  -- 设备状态代码
    ,equip_matnce_id            	  -- 设备维护商编号
    ,equip_matnce_name                -- 设备维护商名称
    ,equip_install_dt           	  -- 设备安装日期
    ,equip_start_use_dt               -- 设备启用日期
    ,equip_stop_use_dt                -- 设备停用日期
    ,cash_flg                   	  -- 现金标志
    ,install_way_cd             	  -- 安装方式代码
    ,dist_cd                    	  -- 行政区划代码
    ,chn_id                     	  -- 渠道编号
    ,equip_install_addr               -- 设备安装地址
    ,equip_kind_name                  -- 设备种类名称
	,job_cd                           -- 任务代码
	,etl_timestamp                    -- 数据处理时间
)
select to_date('${batch_date}','yyyymmdd')		                          -- 数据日期
       ,'9999'		                                                      -- 法人编号
       ,t1.qr_no                                                          -- 设备编号
       ,''                                                                -- 设备IP地址编号
       ,t2.bank_channel_id                                                -- 所属机构编号
       ,'1'                                                               -- 在行标志
	   ,t1.terminal_id                                                    -- 终端编号
       ,''                                                                -- 自助设备设备型号
       ,''                                                                -- 自助设备类型代码
       ,''                                                                -- 自助设备型号描述
       ,''                                                                -- 设备类型名称
       ,''                                                                -- 设备类型名称中文描述
       ,''                                                                -- 设备供应商名称
       ,decode(t1.enabled,'0','2',' ','1',t1.enabled)                     -- 设备状态代码
       ,t1.merchant_id                                                    -- 设备维护商编号
       ,T1.merchant_name                                                  -- 设备维护商名称
       ,t1.bind_time                                                      -- 设备安装日期
       ,t1.bind_time                                                      -- 设备启用日期
       ,''                                                                -- 设备停用日期
       ,''                                                                -- 现金标志
       ,'-'                                                               -- 安装方式代码
       ,'000000'                                                          -- 行政区划代码
       ,'0000'                                                            -- 渠道编号
       ,t1.terminal_address                                               -- 设备安装地址
       ,'二维码'                                                          -- 设备种类名称
       ,'amssf1'                                                          -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')   -- etl处理时间戳
 from ${iol_schema}.amss_cms_vpay_qr_info t1
 left join ${iol_schema}.amss_cms_channel t2
   on t1.channel_id = t2.channel_id
  and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t2.end_dt > to_date('${batch_date}','yyyymmdd')
where trim(t1.qr_no) is not null
  and t1.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t1.end_dt > to_date('${batch_date}','yyyymmdd');
commit;


/* --第二组（共三组）POS终端信息

whenever sqlerror exit sql.sqlcode;
insert + append  into ${icl_schema}.cmm_self_equip_info_ex(
		etl_dt                          -- 数据日期
		,lp_id                          -- 法人编号
		,equip_id                   	  -- 设备编号
    ,equip_ip_addr_id           	  -- 设备IP地址编号
    ,belong_org_id              	  -- 所属机构编号
    ,in_bank_flg                	  -- 在行标志
    ,self_equip_model           	  -- 自助设备设备型号
    ,self_equip_type_cd         	  -- 自助设备类型代码
    ,equip_type_name            	  -- 设备类型名称
    ,equip_type_name_cn_descb   	  -- 设备类型名称中文描述
    ,equip_status_cd            	  -- 设备状态代码
    ,equip_matnce_id            	  -- 设备维护商编号
    ,equip_install_dt           	  -- 设备安装日期
    ,cash_flg                   	  -- 现金标志
    ,install_way_cd             	  -- 安装方式代码
    ,dist_cd                    	  -- 行政区划代码
    ,chn_id                     	  -- 渠道编号
    ,equip_install_addr             -- 设备安装地址
    ,equip_kind_name                -- 设备种类名称
		,job_cd                         -- 任务代码
		,etl_timestamp                  -- 数据处理时间
)
select to_date('${batch_date}','yyyymmdd')		   -- 数据日期
       ,t1.lp_id		                             -- 法人编号
       ,t1.termn_id		                           -- 设备编号
       ,''		                                   -- 设备ip地址编号
       ,t1.termn_belong_bank_num	        	     -- 所属机构编号
       ,'1'		                                   -- 在行标志
       ,t1.termn_model		                       -- 自助设备设备型号
       ,t1.termn_type_cd		                     -- 自助设备类型代码
       ,t1.termn_type_cd		                     -- 设备类型名称
       ,t1.termn_type_cd		                     -- 设备类型名称中文描述
       ,t1.status_cd		                         -- 设备状态代码
       ,t1.mercht_id		                         -- 设备维护商编号
       ,t1.rec_dt		                             -- 设备安装日期
       ,'0'		                                   -- 现金标志
       ,'-'		                                   -- 安装方式代码
       ,t1.dist_cd		                           -- 行政区划代码
       ,t1.mercht_id		                         -- 渠道编号
       ,t1.termn_install_addr		                 -- 设备安装地址
       ,'POS终端'		                             -- 设备种类名称
       ,t1.job_cd                                -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')   -- etl处理时间戳
 from ${iml_schema}.chn_pos_termn_info t1
where t1.create_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t1.id_mark <> 'D'
  and t1.job_cd = 'mrmsf1'
  and t1.termn_id not in (select termn_id
                        from ${iml_schema}.chn_dir_termn_info_h
                       where start_dt <= to_date('${batch_date}', 'yyyymmdd')
                         and end_dt > to_date('${batch_date}', 'yyyymmdd')
                         and id_mark <> 'D'
                         and job_cd = 'mrmsf1'
                         and termn_id is not null);
commit;


--第三组（共三组）直联终端信息

whenever sqlerror exit sql.sqlcode;
insert + append  into ${icl_schema}.cmm_self_equip_info_ex(
		etl_dt                          -- 数据日期
		,lp_id                          -- 法人编号
		,equip_id                   	  -- 设备编号
    ,equip_ip_addr_id           	  -- 设备IP地址编号
    ,belong_org_id              	  -- 所属机构编号
    ,in_bank_flg                	  -- 在行标志
    ,self_equip_model           	  -- 自助设备设备型号
    ,self_equip_type_cd         	  -- 自助设备类型代码
    ,equip_type_name            	  -- 设备类型名称
    ,equip_type_name_cn_descb   	  -- 设备类型名称中文描述
    ,equip_status_cd            	  -- 设备状态代码
    ,equip_matnce_id            	  -- 设备维护商编号
    ,equip_install_dt           	  -- 设备安装日期
    ,cash_flg                   	  -- 现金标志
    ,install_way_cd             	  -- 安装方式代码
    ,dist_cd                    	  -- 行政区划代码
    ,chn_id                     	  -- 渠道编号
    ,equip_install_addr             -- 设备安装地址
    ,equip_kind_name                -- 设备种类名称
		,job_cd                         -- 任务代码
		,etl_timestamp                  -- 数据处理时间
)
select to_date('${batch_date}','yyyymmdd')	   -- 数据日期
       ,t1.lp_id	                      -- 法人编号
       ,t1.termn_id	                    -- 设备编号
       ,''	                            -- 设备ip地址编号
       ,''	                            -- 所属机构编号
       ,'1'	                            -- 在行标志
       ,t1.termnl_id	                  -- 自助设备设备型号
       ,t1.termn_type_cd	              -- 自助设备类型代码
       ,t1.termn_type_cd	              -- 设备类型名称
       ,t1.termn_type_cd	              -- 设备类型名称中文描述
       ,t1.termn_status_cd	            -- 设备状态代码
       ,t1.mercht_id	                  -- 设备维护商编号
       ,t1.install_dt	                  -- 设备安装日期
       ,'0'	                            -- 现金标志
       ,'-'	                            -- 安装方式代码
       ,'-'	                            -- 行政区划代码
       ,t1.seq_num	                    -- 渠道编号
       ,t1.termn_install_addr	          -- 设备安装地址
       ,'直联终端'	                    -- 设备种类名称
       ,t1.job_cd                                                         -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')   -- etl处理时间戳
from ${iml_schema}.chn_dir_termn_info_h t1
where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
 and t1.id_mark <> 'D'
 and t1.job_cd = 'mrmsf1';

commit;
 */


-- 2.3 exchage ex table and target table
alter table ${icl_schema}.cmm_self_equip_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_self_equip_info_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_self_equip_info_ex purge;

-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_self_equip_info', partname => 'p_${batch_date}', granularity => 'partition', degree => 8, cascade => true);